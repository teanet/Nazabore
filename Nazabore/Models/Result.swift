import Foundation
import SwiftProtobuf
import CoreLocation

internal enum Result<TResult> : Equatable {
    case success(TResult)
    case error(Error)
	
	internal static func ==(lhs: Result<TResult>, rhs: Result<TResult>) -> Bool {
		switch (lhs, rhs) {
		case (.success, .success):
			return true
		default:
			return false
		}
	}
}

internal extension Result where TResult == CLLocation {

	internal func near(_ other: Result<CLLocation>) -> Bool {
		switch (self, other) {
			case (.success(let lhsLocation), .success(let rhsLocation)):
				let latDiff = fabs(lhsLocation.coordinate.latitude - rhsLocation.coordinate.latitude)
				let lonDiff = fabs(lhsLocation.coordinate.longitude - rhsLocation.coordinate.longitude)
				return latDiff < 0.001 && lonDiff < 0.001
			default:
				return false
		}
	}

}

internal extension Result where TResult == Data {

	// Только в этом месте делаем do-catch
	internal func unwrap<Proto>(to class: Proto.Type) -> Result<Proto> where Proto: Codable {
		log.debug("Will try to unpack codable response: \(self) for class: \(Proto.self)")
		switch(self) {
			case .success(let data):
				do {
					let object = try JSONDecoder.unwrap.decode(Proto.self, from: data)
					log.debug("Did successfully unpack codable class: \(Proto.self), object: \(object)")
					return Result<Proto>.success(object)
				} catch {
					log.error("Unpack codable error: \(error.localizedDescription)")
					return Result<Proto>.error(CashbackError.apiUnwrapDataError)
				}
			case .error(let error): return Result<Proto>.error(error)
		}
	}

	// Только в этом месте делаем do-catch
	internal func unwrapProto<Proto>(to protoClass: Proto.Type) -> Result<Proto> where Proto: SwiftProtobuf.Message {
		log.debug("Will try to unpack protobuf response: \(self) for class: \(Proto.self)")
		switch(self) {
			case .success(let data):
				guard data.count > 0 else {
					log.error("Couldn't unwrap protobuf zero data for class: \(Proto.self)")
					return Result<Proto>.error(CashbackError.apiProtoUnwrapZeroDataError)
				}

				// Чекнем на ошибку сервера
//				if let errorObject = try? ErrorResponse(serializedData: data) {
//					log.error("Did receive and unwrap server error: \(errorObject)")
//					return Result<Proto>.error(errorObject)
//				}

				guard let object = try? protoClass.init(serializedData: data) else {
					log.error("Couldn't unwrap protobuf data: \(data) to class: \(Proto.self)")
					return Result<Proto>.error(CashbackError.apiProtoUnwrapZeroDataError)
				}

				log.debug("Did successfully unpack protobuf class: \(Proto.self), object: \(object)")
				return Result<Proto>.success(object)
			case .error(let error): return Result<Proto>.error(error)
		}
	}

}
