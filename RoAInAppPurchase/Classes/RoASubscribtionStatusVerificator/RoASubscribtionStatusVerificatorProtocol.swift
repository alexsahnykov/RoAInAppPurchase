//
//  RoASubscribtionStatusVerificatorProtocol.swift
//  Horoscope
//
//  Created by Александр Сахнюков on 24/07/2019.
//  Copyright © 2019 Александр Сахнюков. All rights reserved.
//

 protocol RoASubscribtionStatusVerificatorProtocol {
    
    func getSubscribtionStatus(_ complition: @escaping(SubscribtionStatus, String?)->())
    
}
