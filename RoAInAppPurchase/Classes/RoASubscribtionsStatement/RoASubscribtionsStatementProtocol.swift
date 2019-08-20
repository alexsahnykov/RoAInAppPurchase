//
//  SubscribtionsStatementManager.swift
//  Horoscope
//
//  Created by Александр Сахнюков on 15/07/2019.
//  Copyright © 2019 Александр Сахнюков. All rights reserved.
//

import Foundation

public class RoASubscribtionStatement: RoASubscribtionsStatementProtocol {
    
    public static func checkSubscribeStatusInApp(_ productIdentifire: String) -> SubscribtionStatus {
        switch UserDefaults.standard.bool(forKey: productIdentifire) {
        case true:
            return .avalable
        case false:
            return .unavalable
        }
    }
    
    public func saveSubscribeStatusInApp(_ productIdentifire: String) {
        UserDefaults.standard.set(true, forKey: productIdentifire)
    }
    
    public init() {}
    
}
