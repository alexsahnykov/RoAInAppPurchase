//
//  SubscribtionProducts.swift
//  BrainBooster
//
//  Created by Александр Сахнюков on 12/07/2019.
//  Copyright © 2019 Александр Сахнюков. All rights reserved.
//

import Foundation

public struct RoASubscribtionProductsOwner: RoASubscribtionProductsOwnerProtocol {
    
    var store: RoAIAPManager
    var subscribtionStatment: RoASubscribtionsStatementProtocol?
    var products: Set<String>
    
    init(_ products: Set<String>) {
        let store = RoAIAPManager(products)
        self.store = store
        self.products = products
    }
}

public struct RoACunsumableProductsOwner: RoAProductsOwnerProtocol {
    
    var store: RoAIAPManager
    var products: Set<String>
    
    init(_ products: Set<String>) {
        let store = RoAIAPManager(products)
        self.store = store
        self.products = products
    }
}




