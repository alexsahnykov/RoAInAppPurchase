//
//  RoASubscribtionsStatement.swift
//  Horoscope
//
//  Created by Александр Сахнюков on 24/07/2019.
//  Copyright © 2019 Александр Сахнюков. All rights reserved.
//

public protocol RoAProductsStatementProtocol {
    
    func isAvalable(product: String) -> Bool
    
    func saveInAppStatus(_ product: String, isAvailable: Bool)
    
}

