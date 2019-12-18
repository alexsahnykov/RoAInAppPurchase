//
//  SubscribtionsStatementManager.swift
//  Horoscope
//
//  Created by Александр Сахнюков on 15/07/2019.
//  Copyright © 2019 Александр Сахнюков. All rights reserved.
//

import Foundation

public class RoAProductsnStatement: RoAProductsStatementProtocol {
    
    public  func isAvalable(product: String) -> Bool {
        return UserDefaults.standard.bool(forKey: product)
    }
    
    public func saveInAppStatus(_ productId: String, isAvailable: Bool) {
        switch isAvailable {
        case true:
            UserDefaults.standard.set(true, forKey: productId)
        case false:
            UserDefaults.standard.set(false, forKey: productId)
        }
    }
    
    public init() {}
    
}
