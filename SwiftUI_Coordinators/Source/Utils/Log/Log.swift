//
//  Log.swift
//  MainTarget
//
//  Created by o.sander on 25.06.2023.
//  
//

import Foundation

class Log {

    enum LogEvent: CaseIterable {
        case error
        case warning
        case info
        case debug
        case verbose

        var description: String {
            switch self {
            case .error:   return "[❌]"
            case .warning: return "[⚠️]"
            case .info:    return "[ℹ️]"
            case .debug:   return "[🔧]"
            case .verbose: return "[🔬]"
            }
        }
    }

    fileprivate static var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        let dateFormat = "yyyy-MM-dd hh:mm:ssSSS"
        formatter.dateFormat = dateFormat
        formatter.locale = Locale.current
        formatter.timeZone = TimeZone.current
        return formatter
    }()

    static var enabled: Bool = false
    static var filter: [LogEvent] = LogEvent.allCases

    static func log(consoleMessage: String,
                    level: LogEvent,
                    filename: String = #file,
                    line: Int = #line,
                    funcName: String = #function) {

        guard self.enabled, filter.contains(level) else { return }

        let formattedResult = self.format(consoleMessage, event: level, filename: filename, line: line, funcName: funcName)
        print(formattedResult)
    }

    fileprivate static func format(_ object: Any,
                                   event: LogEvent,
                                   filename: String,
                                   line: Int,
                                   funcName: String) -> String {

        "\(Date().toString()) \(event.description) [\(sourceFileName(filePath: filename))]:\(line) \(funcName): \n➡️ \(object)"
    }

    fileprivate static func sourceFileName(filePath: String) -> String {
        let components = filePath.components(separatedBy: "/")
        return components.isEmpty ? "" : components.last!
    }
}

fileprivate extension Date {
    func toString() -> String {
        Log.dateFormatter.string(from: self)
    }
}

extension Log {
    typealias ProcessBlock = () -> Void
    static func measureTime(for closure: ProcessBlock,
                            filename: String = #file,
                            line: Int = #line,
                            funcName: String = #function) {
        let start = CFAbsoluteTimeGetCurrent()
        closure()
        let diff = CFAbsoluteTimeGetCurrent() - start
        let formattedResult = self.format("Took \(diff) seconds", event: .debug, filename: filename, line: line, funcName: funcName)
        print(formattedResult)
    }
}
