//
//  RoAIAPManager.swift
//  Horoscope
//
//  Created by Александр Сахнюков on 15/07/2019.
//  Copyright © 2019 Александр Сахнюков. All rights reserved.
//
 
import StoreKit

public protocol RoAIAPManagerProtocol: SKProductsRequestDelegate, SKPaymentTransactionObserver {
    
    ///The object that acts as the delegate of the RoAIAPManager.
    
    var delegate: RoAIAPManagerDelegate? {get set}
    
    /// List of in-app products from Apple server
    
    var products: [SKProduct]? {get}
    
    /// Check is Apple purchase server avalable
    ///
    /// The methods in this protocol are implemented bySKPaymentQueue.canMakePayments() object.
    ///
    /// - Parameter callback: A block to execute when the servercallbeck. This block has  return boolean value and takesthe selected action object as its only parameter.
    
    func isIAPServrAvalable (callback: @escaping(Bool)->())
    
    /// The methods send request to server, return a list ofproducts, one product for each valid product identifierprovided in the original request and put this list inobject products into instance RoAIAPManager.
    ///
    /// - Parameter products: Set of products identifiers.
    
    func getProducts()
    
    /// The methods Adds a payment request to the queue.
    ///
    /// - Parameter productWithidentifier: Product identifier.
    
    func purchased(_ productWithidentifier: String)
    
    /// Asks the payment queue to restore previously completed purchases.
    ///
    /** Use this method to restore finished transactions—that is, transactions for which you have already called finishTransaction(_:).
     * You call this method in one of the following situations:
     * To install purchases on additional devices
     * To restore purchases for an application that the user deleted and reinstalled */
    
    func restoreProducts()
    
}
