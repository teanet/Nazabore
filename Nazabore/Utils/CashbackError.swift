import Foundation
import UIKit

internal enum CashbackError: Error, LocalizedError {

	case apiNilDataError
	case apiUnwrapDataError
	case apiProtoUnwrapZeroDataError
	case apiProtoWrapError
	case apiNoGoods(String?)
	case apiGeneral

	var errorDescription: String? {
		switch self {
//			case .apiNilDataError: return "Не нашлось данных"
//			case .apiUnwrapDataError: return "Не смогли распаковать данные"
//			case .apiProtoUnwrapZeroDataError: return "Не пришло данных в ответ"
//			case .apiProtoWrapError: return "Не смогли сериализовать данные"
			case .apiNoGoods: return L10N("main.empty product.title")
			default: return L10N("general.error")
		}
	}

	var failureReason: String? {
		switch self {
			case .apiNoGoods(let message): return message
			default: return L10N("general.error.description")
		}
	}


}
