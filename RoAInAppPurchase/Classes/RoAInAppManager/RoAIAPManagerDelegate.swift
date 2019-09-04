//
//  RoAIAPManagerDelegate.swift
//  Horoscope
//
//  Created by Александр Сахнюков on 15/07/2019.
//  Copyright © 2019 Александр Сахнюков. All rights reserved.
//

import StoreKit

/// Methods for managing actions in transaction different state.
///
/** Use the methods of this protocol to manage the following features:
 * Add action after purchase was deferred.
 * Add action after purchase was purchasing.
 * Add action after purchase was purchased.
 * Add action after purchase was failed.
 * Add action after purchase was restored */

public protocol RoAIAPManagerDelegate: class {
    
    func productRequestDidFinished()
    
    /// Add action after purchase was deferred.
    ///
    /// - Parameter transaction: A currient transaction that was updated.
    
    func deferred(transaction: SKPaymentTransaction, product: SKProduct)
    
    /// Add action after purchase was purchasing.
    ///
    /// - Parameter transaction: A currient transaction that was updated.
    
    func purchasing(transaction: SKPaymentTransaction, product: SKProduct)
    
    /// Add action after purchase was purchased.
    ///
    /// - Parameter transaction: A currient transaction that was updated.
    
    func purchased(transaction: SKPaymentTransaction, product: SKProduct)
    
    /// Add action after purchase was purchasing.
    ///
    /// - Parameter transaction: A currient transaction that was updated.
    
    func failed(transaction: SKPaymentTransaction, product: SKProduct)
    
    /// Add action after purchase was failed.
    ///
    /// - Parameter transaction: A currient transaction that was updated.
    
    func restored(transaction: SKPaymentTransaction, product: SKProduct)
    
    /// Add action after purchase was restored.
    ///
    /// - Parameter transaction: A currient transaction that was updated.
    
}

extension RoAIAPManagerDelegate {
    
    func deferred(transaction: SKPaymentTransaction, product: SKProduct) {
        return
    }
    
    func purchasing(transaction: SKPaymentTransaction, product: SKProduct) {
        return
    }
    
    func purchased(transaction: SKPaymentTransaction, product: SKProduct) {
        return
    }
    
    func failed(transaction: SKPaymentTransaction, product: SKProduct) {
        return
    }
    
    func restored(transaction: SKPaymentTransaction, product: SKProduct) {
        return
    }
    
    func productRequestDidFinished() {
        return
    }
}
