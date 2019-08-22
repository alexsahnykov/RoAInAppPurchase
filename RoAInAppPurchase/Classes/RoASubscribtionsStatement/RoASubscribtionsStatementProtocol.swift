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
    
    public func checkSubscribeStatus() -> RoASubscribtionStatus {
        switch UserDefaults.standard.bool(forKey: userDefaultsSubscribtionKey) {
        case true:
            return .avalable
        case false:
            return .unavalable
        }
    }
    
    public func setSubscribeStatus(_ isAvailable: RoASubscribtionStatus) {
        switch isAvailable {
        case .avalable:
            UserDefaults.standard.set(true, forKey: userDefaultsSubscribtionKey)
        case .unavalable:
            UserDefaults.standard.set(false, forKey: userDefaultsSubscribtionKey)
        }
    }
    
    private init() {}
    
}
