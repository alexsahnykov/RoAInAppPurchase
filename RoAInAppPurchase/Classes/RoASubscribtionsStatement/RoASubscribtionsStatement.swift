//
//  SubscribtionsStatementManager.swift
//  Horoscope
//
//  Created by Александр Сахнюков on 15/07/2019.
//  Copyright © 2019 Александр Сахнюков. All rights reserved.
//

import Foundation

public class RoASubscribtionStatement: RoASubscribtionsStatementProtocol {
    
    private let userDefaultsSubscribtionKey = "userDefaultsSubscribtionKey"
    
    public  func checkSubscribeStatus() -> RoASubscribtionStatus {
        switch UserDefaults.standard.bool(forKey: "enable") {
        case true:
            return .avalable
        case false:
            return .unavalable
        }
    }
    
    public  func saveSubscribeStatusInApp(_ isAvailable: RoASubscribtionStatus) {
        switch isAvailable {
        case .avalable:
            UserDefaults.standard.set(true, forKey: "enable")
        case .unavalable:
            UserDefaults.standard.set(false, forKey: "enable")
        }
    }
    
    public init() {}
    
}
