//
//  AppConfig.swift
//  MainTarget
//
//  Created by o.sander on 08.06.2023.
//  
//
    
import Foundation

class AppConfig {

    let networkBaseURL: String
    let loggingEnabled: Bool

    convenience init() {
        self.init(with: AppConfigBridge())
    }

    init(with bridge: AppConfigBridge) {
        self.networkBaseURL = bridge.baseURL
        self.loggingEnabled = bridge.loggingEnabled
    }
}
