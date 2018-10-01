import XCGLogger
import Foundation

let log = XCGLogger(identifier: "advancedLogger", includeDefaultDestinations: false)

public class Logger {

	static let logFilePath: URL = {
		let url = Logger.cacheDirectory.appendingPathComponent(Constants.logFileName)
		return url
	}()

	static let cacheDirectory: URL = {
		let cacheDirectoryURL = FileManager.cacheDirectoryURL()
		return cacheDirectoryURL
	}()

	static let formatter = EmojiFormatter()

	static func configure() {
		// Create a destination for the system console log (via NSLog)
		let systemDestination = AppleSystemLogDestination(identifier: "advancedLogger.systemDestination")

		// Optionally set some configuration options
		#if DEBUG
			systemDestination.outputLevel = .debug
		#else
			systemDestination.outputLevel = .info
		#endif

		systemDestination.showLogIdentifier = false
		systemDestination.showFunctionName = true
		systemDestination.showThreadName = true
		systemDestination.showLevel = true
		systemDestination.showFileName = true
		systemDestination.showLineNumber = true
		systemDestination.showDate = true
		systemDestination.formatters = [Logger.formatter]

		// Add the destination to the logger
		log.add(destination: systemDestination)

		// Create a file log destination
		let fileDestination = AutoRotatingFileDestination(writeToFile: Logger.logFilePath, identifier: "advancedLogger.fileDestination", shouldAppend: true, appendMarker: ">>> Append Session")

		// Optionally set some configuration options
		fileDestination.outputLevel = .info
		fileDestination.showLogIdentifier = false
		fileDestination.showFunctionName = true
		fileDestination.showThreadName = true
		fileDestination.showLevel = true
		fileDestination.showFileName = true
		fileDestination.showLineNumber = false
		fileDestination.showDate = true
		fileDestination.formatters = [Logger.formatter]
		fileDestination.targetMaxFileSize = 1024 * 1024
		fileDestination.targetMaxLogFiles = 10
		fileDestination.targetMaxTimeInterval = 60 * 60 * 24

		// Process this destination in the background
		fileDestination.logQueue = XCGLogger.logQueue

		// Add the destination to the logger
		log.add(destination: fileDestination)

		// Add basic app info, version info etc, to the start of the logs
		log.logAppDetails()

		logCurrentRunDetails()
	}

	static func logAttachmentData() -> Data {
		let filePath = Logger.cacheDirectory.appendingPathComponent("brawlstats.log")
		if let fileData = try? Data(contentsOf: filePath) {
			return fileData
		}
		
		return Data.init()
	}

	fileprivate static func logCurrentRunDetails() {
		log.info("| Application Version: \(Constants.currentVersion)")
		log.info("| Application Build: \(Constants.currentBuild)")
		log.info("| Platform Model: \(Constants.mobilePlatformVerboseModel)")
		log.info("| Platform OS: \(Constants.mobileOSName) \(Constants.platformOSVersion)")
		log.info("| Bundle id: \(Constants.bundleID)")
	}

}

extension XCGLogger {

	func filePath() -> URL {
		return Logger.logFilePath
	}

}

internal class EmojiFormatter: LogFormatterProtocol {

	func format(logDetails: inout LogDetails, message: inout String) -> String {
		switch logDetails.level {
			case .debug: message = "🗒 " + message
			case .error: message =  "⛔️ " + message
			case .info: message =  "🗒 " + message
			case .none: message =  "🗒 " + message
			case .severe: message =  "🗒 " + message
			case .verbose: message =  "🗒 " + message
			case .warning: message =  "🌝 " + message
		}

		return message
	}

	var debugDescription: String = ""

}
