//
//  RoASubscribtionStatusVerificatorProtocol.swift
//  Horoscope
//
//  Created by Александр Сахнюков on 24/07/2019.
//  Copyright © 2019 Александр Сахнюков. All rights reserved.
//

public protocol RoAProductsVerificatorProtocol {

    func updateProductsStatus(_ products: Set<String>?, complition: @escaping(_ avalableProducts: [String]) -> Void)
    
}

