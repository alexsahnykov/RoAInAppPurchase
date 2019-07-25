//
//  SubscribtionsStatementManager.swift
//  Horoscope
//
//  Created by Александр Сахнюков on 15/07/2019.
//  Copyright © 2019 Александр Сахнюков. All rights reserved.
//

import Foundation

class RoASubscribtionStatement: RoASubscribtionsStatementProtocol {
    func checkSubscribeStatusInApp(_ productIdentifire: String) -> SubscribtionStatus {
        switch UserDefaults.standard.bool(forKey: productIdentifire) {
        case true:
            return .avalable
        case false:
            return .unavalable
        }
    }
    
    func saveSubscribeStatusInApp(_ productIdentifire: String) {
        UserDefaults.standard.set(true, forKey: productIdentifire)
    }
    
    func expirationDateFor(_ identifier : String) -> Date?{
        return UserDefaults.standard.object(forKey: identifier) as? Date
    }
    
}
