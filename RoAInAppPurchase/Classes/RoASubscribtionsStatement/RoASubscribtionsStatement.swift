//
//  RoASubscribtionsStatement.swift
//  Horoscope
//
//  Created by Александр Сахнюков on 24/07/2019.
//  Copyright © 2019 Александр Сахнюков. All rights reserved.
//

protocol RoASubscribtionsStatementProtocol {
    
    func checkSubscribeStatusInApp(_ productIdentifire: String) -> SubscribtionStatus
    
    func saveSubscribeStatusInApp(_ productIdentifire: String)
    
}
