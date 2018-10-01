import Alamofire
import AlamofireNetworkActivityIndicator
import CoreLocation
import SwiftProtobuf

internal class APIService {

	private let manager: SessionManager
	private var headers: [String : String]

	private private(set) var baseURLString: String = ""

	required init(
//		userId: APIUserId,
//		userToken: APIUserToken,
//		deviceId: APIDeviceId,
//		sessionId: APISessionId,
//		carrier: String
	) {
//		assert(!Constants.currentVersion.isEmpty, "Invalid current version value")
//		assert(!Constants.currentBuild.isEmpty, "Invalid current build value")
//		assert(!userId.rawValue.isEmpty, "Invalid user id")
//		assert(!sessionId.rawValue.isEmpty, "Invalid session id")

		let headers: [String : String] = [
			"X-Current-App-Build" : Constants.currentBuild,
			"X-Current-App-Version" : Constants.currentVersion,
			"X-Device-Vendor" : Constants.mobileVendorName,
			"X-Device-Model" : Constants.mobilePlatformModel,
			"X-Device-Platform" : Constants.mobileOSName,
			"X-Device-Os" : Constants.mobileOSName,
			"X-Device-Os-Version" : Constants.platformOSVersion,
//			"X-Device-Id" : deviceId.rawValue,
//			"X-User-Session-UUID": sessionId.rawValue,
//			"X-User-UUID": userId.rawValue,
			"X-User-Language": Constants.currentLanguage,
			"X-User-Locale": Constants.currentLocale,
			"X-User-Time-Zone": Constants.currentTimeZone,
//			"X-User-Token" : userToken.rawValue,
//			"X-Carrier-Name": carrier
		]

		let configuration = URLSessionConfiguration.default
		configuration.timeoutIntervalForRequest = Constants.timeoutIntervalForRequest
		configuration.timeoutIntervalForResource = Constants.timeoutIntervalForRequest
		configuration.requestCachePolicy = .reloadIgnoringLocalAndRemoteCacheData
		self.manager = SessionManager(configuration: configuration)

		// Вот здесь надо как-то правильно прокинуть дефолтные хедэры в менеджер аламофайера
		self.headers = headers

		NetworkActivityIndicatorManager.shared.isEnabled = true
		NetworkActivityIndicatorManager.shared.completionDelay = 0.3
		self.configure(forBaseUrlString: Constants.baseUrlString)
//		log.info("Did create API Service with sessionId: \(sessionId.rawValue), userId: \(userId.rawValue)")
	}

	internal func configure(forBaseUrlString urlString: String) {
		self.baseURLString = urlString
	}

//	internal func configure(city: City) {
//		self.headers["X-City-Id"] = "\(city.iid.rawValue)"
//	}

//	internal func configure(userId: APIUserId, userToken: APIUserToken) {
//		self.headers["X-User-UUID"] = userId.rawValue
//		self.headers["X-User-Token"] = userToken.rawValue
//	}

	fileprivate func protoRequest(httpMethod: HTTPMethod,
								  method: String,
								  protoObject: SwiftProtobuf.Message,
								  callback: @escaping ((Result<Data>) -> Void)) {
		guard let data = try? protoObject.serializedData() else {
			callback(Result<Data>.error(CashbackError.apiProtoWrapError))
			return
		}

		self.request(httpMethod: httpMethod,
					 method: method,
					 params: nil,
					 body: data,
					 callback: callback)
	}

	fileprivate func request(httpMethod: HTTPMethod,
	                         method: String,
	                         params: [String : Any]?,
	                         body: Data? = nil,
	                         callback: @escaping ((Result<Data>) -> Void)) {
		log.debug("Will perform request: \(method), HTTPMethod: \(httpMethod), params: \(String(describing: params))")

		let urlString = self.baseURLString + method
		var reqHeaders = self.headers

		if httpMethod == .post {
			reqHeaders["Content-Type"] = "application/json"
		}

		// Эта грязь для пуш-токенов
		var request: DataRequest
		if let body = body {
			var req = URLRequest(url: URL(string: urlString)!)
			req.httpMethod = httpMethod.rawValue
			req.httpBody = body
			if httpMethod == .post {
				reqHeaders["Content-Type"] = "application/grpc+proto"
			}

			for (key, value) in reqHeaders {
				req.setValue(value, forHTTPHeaderField: key)
			}

			request = self.manager.request(req)
		} else {
			let encoding: ParameterEncoding = httpMethod == .post
				? JSONEncoding.default
				: URLEncoding.default
			request = self.manager.request(urlString,
			                               method: httpMethod,
			                               parameters: params,
			                               encoding: encoding,
			                               headers: reqHeaders)
		}

		request.responseData(completionHandler: { response in
			let result: Result<Data>

			if let data = response.data, let code = response.response?.statusCode {
				if case 200..<300 = code {
					// Хороший результат с сервера
					log.debug("Did successfully complete request: \(method), HTTPMethod: \(httpMethod), params: \(String(describing: params))")
					result = .success(data)
				} else {
					// Ошибка сервера
					let errorResult: Result<Data> = .success(data)
					let errorResponse = errorResult.unwrapProto(to: ErrorResponse.self)
					switch errorResponse {
						case .success(let errorModel): result = .error(errorModel)
						case .error: result = errorResult
					}
				}
			} else if let error = response.error {
				// Ошибки сети
				log.error("Did receive error: \(error) for request: \(method), HTTPMethod: \(httpMethod), params: \(String(describing: params))")
				result = .error(CashbackError.apiGeneral)
			} else {
				// Прочие ошибки
				log.error("Did receive nil data response request: \(method), HTTPMethod: \(httpMethod), params: \(String(describing: params))")
				result = .error(CashbackError.apiNilDataError)
			}

			callback(result)
		})
	}

}

internal extension APIService { // + API


	func get(center: CLLocation, completion: @escaping (Result<ListMarkersResponse>) -> Void) {
//		http://10.54.193.61:8080/nazabore/api/1.0/markers?lon=1.12&lat=3&zoom=5
		let params = [
			"lon": center.coordinate.longitude,
			"lat": center.coordinate.latitude,
			"zoom": 5,
		]
		self.request(httpMethod: .get, method: "markers", params: params) { (response) in
			completion(response.unwrapProto(to: ListMarkersResponse.self))
		}
	}

//	internal func fetchCities(completion: @escaping (Result<CitiesResponse>) -> Void) {
//		let method = "cities"
//		self.request(httpMethod: .get, method: method, params: nil, body: nil) { response in
//			completion(response.unwrapProto(to: CitiesResponse.self))
//		}
//	}
//
//	internal func postWithdraw(withdraw: Withdraw, completion: @escaping (Result<OkResponse>) -> Void) {
//		let method = "profile/withdraws"
//		self.protoRequest(httpMethod: .post, method: method, protoObject: withdraw.request) { response in
//			completion(response.unwrapProto(to: OkResponse.self))
//		}
//	}
//
//	internal func fetchDetectedCity(location: CLLocation?, completion: @escaping (Result<CityResponse>) -> Void) {
//		let method = "cities/detect"
//
//		let params = location?.dictionaryRepresentation
//		self.request(httpMethod: .get, method: method, params: params, body: nil) { response in
//			completion(response.unwrapProto(to: CityResponse.self))
//		}
//	}
//
//	internal func fetchProductsMain(for city: CityId?, completion: @escaping (Result<MainProductsResponse>) -> Void) {
//		let method = "catalog/products/main"
//
//		var params: [String : Any] = [:]
//		if let city = city, city.rawValue != City.unsupportedId {
//			params["city_id"] = city.rawValue
//		}
//		self.request(httpMethod: .get, method: method, params: params) { response in
//			completion(response.unwrapProto(to: MainProductsResponse.self))
//		}
//	}
//
//	internal func fetchReceipts(offset: Int = 0, limit: Int = 10, completion: @escaping(Result<ReceiptsResponse>) -> Void) {
//		let method = "receipts"
//		let params = [
//			"offset": offset,
//			"limit": limit
//		]
//		self.request(httpMethod: .get, method: method, params: params) { response in
//			completion(response.unwrapProto(to: ReceiptsResponse.self))
//		}
//	}
//
//	internal func fetchProfile(completion: @escaping(Result<ProfileResponse>) -> Void) {
//		let method = "profile"
//		self.request(httpMethod: .get, method: method, params: nil) { response in
//			completion(response.unwrapProto(to: ProfileResponse.self))
//		}
//	}
//
//	internal func fetchNearbyPlaces(for city: CityName, location: CLLocation?, completion: @escaping(Result<NearbyPlacesResponse>) -> Void) {
//		let method = "cities/\(city.rawValue)/nearby-places"
//		let params = location?.dictionaryRepresentation
//		self.request(httpMethod: .get, method: method, params: params) { response in
//			completion(response.unwrapProto(to: NearbyPlacesResponse.self))
//		}
//	}
//
//	internal func postEnter(region: CLRegion, accuracy: Double) {
//		guard let req = region.request(with: accuracy) else { return }
//		let method = "profile/places/actions/enter/\(region.identifier)"
//
//		self.protoRequest(httpMethod: .post, method: method, protoObject: req) { response in
//			let unwrappedResponse = response.unwrapProto(to: OkResponse.self)
//			if case .error(let error) = unwrappedResponse {
//				log.error("Visited place response error: \(error) for place: \(region)")
//			}
//		}
//	}
//
//	internal func postLeave(region: CLRegion, accuracy: Double) {
//		guard let req = region.request(with: accuracy) else { return }
//		let method = "profile/places/actions/leave/\(region.identifier)"
//
//		self.protoRequest(httpMethod: .post, method: method, protoObject: req) { response in
//			let unwrappedResponse = response.unwrapProto(to: OkResponse.self)
//			if case .error(let error) = unwrappedResponse {
//				log.error("Visited place response error: \(error) for place: \(region)")
//			}
//		}
//	}
//
//	internal func postVisit(visit: CLVisit) {
//		let method = "profile/places/actions/visit"
//
//		let req = AddVisitedPlaceRequest.with {
//			$0.accuracy = visit.horizontalAccuracy
//			$0.location = visit.coordinate.geoPoint
//
//			if visit.arrivalDate != .distantPast {
//				$0.enterTime = visit.arrivalDate.timeStamp
//			}
//
//			if visit.departureDate != .distantFuture {
//				$0.leaveTime = visit.departureDate.timeStamp
//			}
//		}
//		self.protoRequest(httpMethod: .post, method: method, protoObject: req) { response in
//			let unwrappedResponse = response.unwrapProto(to: OkResponse.self)
//			if case .error(let error) = unwrappedResponse {
//				log.error("Visited place response error: \(error) for visit: \(visit)")
//			}
//		}
//	}
//
//	internal func postUserLocation(location: CLLocation, completion: @escaping(Result<OkResponse>) -> Void) {
//		let method = "profile/actions/add-location"
//		let req = AddLocationRequest.with { $0.location = location.geoPoint }
//		self.protoRequest(httpMethod: .post, method: method, protoObject: req) { response in
//			completion(response.unwrapProto(to: OkResponse.self))
//		}
//	}
//
//	internal func postPushToken(token: String, callback: @escaping VoidBlock) {
//		let method = "profile/actions/add-push-token"
//
//		let req = AddPushTokenRequest.with {
//			$0.token = token
//			$0.platform = PlatformType.iOS.proto
//		}
//
//		self.protoRequest(httpMethod: .post, method: method, protoObject: req) { response in
//			let unwrappedResponse = response.unwrapProto(to: OkResponse.self)
//			if case .error(let error) = unwrappedResponse {
//				log.error("Set token error: \(error) for token: \(token)")
//			} else {
//				callback()
//			}
//		}
//	}
//
//	internal func authUser(with provider: AuthProvider, userId: String, userToken: String, userEmail: String?, completion: @escaping (Result<AuthResponse>) -> Void) {
//		let method = "profile/auth"
//
//		let req = AddAuthRequest.with {
//			$0.provider = provider.proto
//			$0.id = userId
//			$0.token = userToken
//			if let email = userEmail {
//				$0.email = email
//			}
//		}
//
//		self.protoRequest(httpMethod: .post, method: method, protoObject: req) { response in
//			completion(response.unwrapProto(to: AuthResponse.self))
//		}
//	}
//
//	internal func unauthUser(completion: @escaping (Result<AuthResponse>) -> Void) {
//		let method = "profile/auth/logout"
//
//		self.request(httpMethod: .post, method: method, params: nil) { response in
//			completion(response.unwrapProto(to: AuthResponse.self))
//		}
//	}
//
//	internal func postReceipt(code: String, location: CLLocation?, completion: @escaping(Result<OkResponse>) -> Void) {
//		let method = "receipts"
//
//		let req = AddReceiptRequest.with {
//			$0.code = code
//			if let location = location {
//				$0.location = location.geoPoint
//			}
//		}
//
//		self.protoRequest(httpMethod: .post, method: method, protoObject: req) { response in
//			completion(response.unwrapProto(to: OkResponse.self))
//		}
//	}

//	internal func register(completion: @escaping(Result<OkResponse>) -> Void) {
//		let method = "profile/auth/register"
//
//		self.request(httpMethod: .post, method: method, params: nil) { response in
//			completion(response.unwrapProto(to: OkResponse.self))
//		}
//	}

//	internal func register(idfa: String, vendorId: String, callback: @escaping VoidBlock) {
//		let method = "profile/actions/register-idfa"
//
//		let req = RegisterIdfaRequest.with {
//			$0.idfa = idfa
//			$0.vendorID = vendorId
//			$0.platform = PlatformType.iOS.proto
//		}
//
//		self.protoRequest(httpMethod: .post, method: method, protoObject: req) { response in
//			let unwrappedResponse = response.unwrapProto(to: OkResponse.self)
//			if case .error(let error) = unwrappedResponse {
//				log.error("Register idfa response error: \(error)")
//			} else {
//				callback()
//			}
//		}
//	}
//
//	internal func unregister(idfa: String, vendorId: String, callback: @escaping VoidBlock) {
//		let method = "profile/actions/unregister-idfa"
//
//		let req = RegisterIdfaRequest.with {
//			$0.idfa = idfa
//			$0.vendorID = vendorId
//			$0.platform = PlatformType.iOS.proto
//		}
//
//		self.protoRequest(httpMethod: .post, method: method, protoObject: req) { response in
//			let unwrappedResponse = response.unwrapProto(to: OkResponse.self)
//			if case .error(let error) = unwrappedResponse {
//				log.error("Register idfa response error: \(error)")
//			} else {
//				callback()
//			}
//		}
//	}
//
//	internal func fetchProduct(for productId: ProductId, completion: @escaping(Result<ProductResponse>) -> Void) {
//		let method = "catalog/products/\(productId.rawValue)"
//
//		self.request(httpMethod: .get, method: method, params: nil) { response in
//			completion(response.unwrapProto(to: ProductResponse.self))
//		}
//	}
//
//	internal func fetchReceipt(for receiptId: ReceiptId, completion: @escaping(Result<ReceiptResponse>) -> Void) {
//		let method = "receipts/\(receiptId.rawValue)"
//
//		self.request(httpMethod: .get, method: method, params: nil) { response in
//			completion(response.unwrapProto(to: ReceiptResponse.self))
//		}
//	}
//
//	internal func fetchMessages(completion: @escaping (Result<FeedMessagesResponse>) -> Void) {
//		let method = "profile/feed"
//		self.request(httpMethod: .get, method: method, params: nil) { response in
//			completion(response.unwrapProto(to: FeedMessagesResponse.self))
//		}
//	}
//
//	internal func fetchMarkRead(message: FeedMessage, completion: @escaping (Result<OkResponse>) -> Void) {
//		let method = "profile/feed/\(message.id)/actions/mark-as-read"
//		self.request(httpMethod: .post, method: method, params: nil) { response in
//			completion(response.unwrapProto(to: OkResponse.self))
//		}
//	}

}

//extension CLRegion {
//
//	func request(with accuracy: Double) -> AddVisitedPlaceRequest? {
//		if let region = self as? CLCircularRegion {
//			let request = AddVisitedPlaceRequest.with {
//				$0.location = region.center.geoPoint
//				$0.accuracy = accuracy
//			}
//
//			return request
//		}
//
//		return nil
//	}
//
//	func params() -> [String : Any]? {
//		if let region = self as? CLCircularRegion {
//			return [ "location": region.center.dictionaryRepresentation ]
//		}
//		return nil
//	}
//}
