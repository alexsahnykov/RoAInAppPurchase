//
//  RoASubscribtionStatusVerificatorProtocol.swift
//  Horoscope
//
//  Created by Александр Сахнюков on 24/07/2019.
//  Copyright © 2019 Александр Сахнюков. All rights reserved.
//

public protocol RoASubscribtionStatusVerificatorProtocol {

    func getSubscribtionStatus(_ complition: @escaping(RoASubscribtionStatus, _ latestProduct: String?) -> Void)
    
}
