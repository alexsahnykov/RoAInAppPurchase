//
//  SubscribtionsStatementManager.swift
//  Horoscope
//
//  Created by Александр Сахнюков on 15/07/2019.
//  Copyright © 2019 Александр Сахнюков. All rights reserved.
//

import Foundation

public class RoASubscribtionStatement: RoASubscribtionsStatementProtocol {
    
    public static let shared = RoASubscribtionStatement()
    
    private let userDefaultsSubscribtionKey = "userDefaultsSubscribtionKey"
    
    public static func checkSubscribeStatus() -> RoASubscribtionStatus {
        switch UserDefaults.standard.bool(forKey: "enable") {
        case true:
            return .avalable
        case false:
            return .unavalable
        }
    }
    
    public static func saveSubscribeStatusInApp(_ isAvailable: RoASubscribtionStatus) {
        switch isAvailable {
        case .avalable:
            UserDefaults.standard.set(true, forKey: "enable")
        case .unavalable:
            UserDefaults.standard.set(false, forKey: "enable")
        }
    }
    
    private init() {}
    
}
