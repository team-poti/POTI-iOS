//
//  PotiLogger.swift
//  POTI-iOS
//
//  Created by 김나연 on 1/9/26.
//

import OSLog

extension OSLog {
    static let subsystem = Bundle.main.bundleIdentifier!
    static let network = OSLog(subsystem: subsystem, category: "Network")
    static let lifecycle = OSLog(subsystem: subsystem, category: "Lifecycle")
    static let debug = OSLog(subsystem: subsystem, category: "Debug")
    static let data = OSLog(subsystem: subsystem, category: "Data")
    static let error = OSLog(subsystem: subsystem, category: "Error")
}

enum LogLevel {
    case network
    case lifecycle
    case debug
    case data
    case error(error: Error)
    
    var category: String {
        switch self {
        case .network:
            "Network"
        case .lifecycle:
            "LifeCycle"
        case .debug:
            "Debug"
        case .data:
            "Data"
        case .error:
            "Error"
        }
    }
        
    var osLog: OSLog {
        switch self {
        case .network:
                .network
        case .lifecycle:
                .lifecycle
        case .debug:
                .debug
        case .data:
                .data
        case .error:
                .error
        }
    }
        
    var osLogType: OSLogType {
        switch self {
        case .network, .lifecycle, .data:
                .default
        case .debug:
                .debug
        case .error:
                .error
        }
    }
        
    var shouldShowLogInRelease: Bool {
        switch self {
        case .error:
            true
        default:
            false
        }
    }
}

struct PotiLogger {
    
    private static var isDebugMode: Bool {
        #if DEBUG
        return true
        #else
        return false
        #endif
    }
        
    private static func shouldShowLog(level: LogLevel) -> Bool {
        if isDebugMode { return true }
        
        return level.shouldShowLogInRelease
    }
        
    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()
        
    private static var timestamp: String {
        dateFormatter.string(from: Date())
    }
        
    private static func log(
        level: LogLevel,
        message: Any,
        file: String,
        function: String
    ) {
        guard shouldShowLog(level: level) else { return }
        
        let logger = Logger(subsystem: OSLog.subsystem, category: level.category)
        let logMessage = "\(message)"
        let fileName = (file as NSString).lastPathComponent
        
        switch level {
        case .network:
            logger.log("[🛜 Network] [Date: \(timestamp)] [\(fileName) -> \(function)]: \(logMessage)")
        case .lifecycle:
            logger.log("[🔄 LifeCycle] [Date: \(timestamp)] [\(fileName) -> \(function)]: \(logMessage)")
        case .debug:
            logger.debug("[🐛 Debug] [Date: \(timestamp)] [\(fileName) -> \(function)]: \(logMessage)")
        case .data:
            logger.info("[📊 Data] [Date: \(timestamp)] [\(fileName) -> \(function)]: \(logMessage)")
        case .error(let error):
            logger.error("[❌ Error] [Date: \(timestamp)] [\(fileName) -> \(function)]: \(error.localizedDescription)")
        }
    }
        
    static func network(
        _ message: Any,
        file: String = #file,
        function: String = #function
    ) {
        log(level: .network, message: message, file: file, function: function)
    }
        
    static func lifecycle(
        _ message: Any,
        file: String = #file,
        function: String = #function
    ) {
        log(level: .lifecycle, message: message, file: file, function: function)
    }
        
    static func debug(
        _ message: Any,
        file: String = #file,
        function: String = #function
    ) {
        log(level: .debug, message: message, file: file, function: function)
    }
        
    static func data(
        _ message: Any,
        file: String = #file,
        function: String = #function
    ) {
        log(level: .data, message: message, file: file, function: function)
    }
        
    static func error(
        _ error: Error,
        file: String = #file,
        function: String = #function
    ) {
        log(level: .error(error: error), message: "", file: file, function: function)
    }
}
