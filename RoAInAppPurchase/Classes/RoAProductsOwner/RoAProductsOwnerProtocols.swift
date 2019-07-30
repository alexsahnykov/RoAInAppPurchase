//
//  RoAProductsOwnerProtocols.swift
//  Horoscope
//
//  Created by Александр Сахнюков on 24/07/2019.
//  Copyright © 2019 Александр Сахнюков. All rights reserved.
//

 protocol RoAProductsOwnerProtocol {
    
    var products: Set<String> {get set}
    
    var store: RoAIAPManager {get}
    
    init(_ products: Set<String>)
}

 protocol RoASubscribtionProductsOwnerProtocol: RoAProductsOwnerProtocol {
    
    var subscribtionStatment: RoASubscribtionsStatementProtocol? {get}
    
}
