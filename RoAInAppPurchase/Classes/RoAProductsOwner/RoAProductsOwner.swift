//
//  SubscribtionProducts.swift
//  BrainBooster
//
//  Created by Александр Сахнюков on 12/07/2019.
//  Copyright © 2019 Александр Сахнюков. All rights reserved.
//

import Foundation

public struct RoASubscribtionProductsOwner: RoAProductsOwnerProtocol {
    
    public var store: RoAIAPManager
    public var products: Set<String>
    
    public init(_ products: Set<String>) {
        let store = RoAIAPManager(products)
        self.store = store
        self.products = products
    }
}

public struct RoACunsumableProductsOwner: RoAProductsOwnerProtocol {
    
    public var store: RoAIAPManager
    public var products: Set<String>
    
    public init(_ products: Set<String>) {
        let store = RoAIAPManager(products)
        self.store = store
        self.products = products
    }
}




