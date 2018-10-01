import UIKit

internal struct Constants
{
	static let baseUrlString: String = {
		#if DEBUG

		return "http://127.0.0.0:8080/nazabore/api/1.0/"
//		return "http://10.54.193.61:8080/nazabore/api/1.0/"
//		return "http://api.cashback.steelhoss.xyz/cashback/api/0.1/"
//		return "http://cashback.web-staging.2gis.ru/cashback/api/0.1/"
//		return "http://10.54.4.31:8080/cashback/api/0.1/"
		#else
//		return "http://10.54.193.61:8080/nazabore/api/1.0/"
		return "http://127.0.0.1:8080/nazabore/api/1.0/"
		#endif
	}()
	
	static let timeoutIntervalForRequest: TimeInterval = {
		#if DEBUG
		return 30
		#else
		return 30
		#endif
	}()

	static let amplitudeAPIKey: String = {
		#if DEBUG
		return "e9a69e3ab1dd54ae3970bfd16ff3ef52"
		#else
		return "8a087adc7415a5b93cae3b05f24f65b3"
		#endif
	}()

	static let vkAppIdKey: String = {
		#if DEBUG
		return "6463686"
		#else
		return "6463686" // Бой
		#endif
	}()

	static let currentVersion = Bundle.main.infoDictionary?[String(kCFBundleVersionKey)]! as! String
	static let currentBuild = Bundle.main.infoDictionary?["CFBundleShortVersionString"]! as! String
	static let bundleID = Bundle.main.bundleIdentifier ?? "unknown"
	static let mobilePlatformModel = UIDeviceHardware.platformModelString()
	static let mobilePlatformVerboseModel = UIDeviceHardware.platformString()
	static let mobileOSName = "ios"
	static let mobileVendorName = "Apple"
	static let platformOSVersion = UIDevice.current.systemVersion
	static let currentLanguage = Locale.preferredLanguages.first ?? "ru-RU"
	static let currentLocale = Locale.current.identifier
	static let currentTimeZone = TimeZone.current.identifier
	static let logFileName = "cashback.log"
	static let feedbackEmail = "check@2gis.ru"
	static let agreementURL = URL(string: "https://check.2gis.ru/legal")!
	static let phoneMask = "{+7} ([000]) [000]-[00]-[00]"
	static let yandexMask = "[00000] [000] [000][99999]"
	static let bankMask = "[000] [000] [000] [0000] [0000] [000]"
	static let cardMask = "[0000] [0000] [0000] [0000]"
	static let shareURL = URL(string: "https://check.2gis.ru/share")!
}
