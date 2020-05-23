//
//  Logger.swift
//  Sportgate
//
//  Created by Maxim Vitovitsky on 28.12.2019.
//  Copyright © 2019 NapoleonIT. All rights reserved.
//

import os.log
import Foundation

internal class Logger {
    
    enum Category: String {
        case info
        case warning
        case success
        case error
    }
    
    private init() { }
    
    static func info(_ object: Any, _ function: String = #function) {
        log("ℹ️ \(function): \(object)", function, category: .info)
    }
    
    static func success(_ object: Any, _ function: String = #function) {
        log("✅ \(function): \(object)", function, category: .success)
    }
    
    static func warning(_ object: Any, _ function: String = #function) {
        log("⚠️ \(function): \(object)", function, category: .warning)
    }
    
    static func error(_ object: Any, _ function: String = #function) {
        log("❌ \(function): \(object)", function, category: .error)
    }
    
    private static func log(_ text: String, _ function: String, category: Category) {
        let log = OSLog(subsystem: Bundle.main.bundleIdentifier!, category: category.rawValue)
        let formattedText = text.replacingOccurrences(of: "\n", with: "\n     ")
        os_log("\n🛠%@", log: log, formattedText)
    }
    
}
