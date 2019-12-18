//
//  IAPManager.swift
//  WallPapers
//
//  Created by Александр Сахнюков on 04/02/2019.
//  Copyright © 2019 Александр Сахнюков. All rights reserved.
//

import StoreKit


public final class RoAIAPManager: NSObject {
    
    static public let shared = RoAIAPManager()
    
    private override init() {}
    
    weak public var delegate: RoAIAPManagerDelegate?
    
    public var productsStatment: RoAProductsStatementProtocol?
    
    public var productsVerificator: RoAProductsVerificatorProtocol?
    
    private(set) public var products: [SKProduct]?
    
    public var productsIDs: Set<String>?
    
    public var paymentQueue = SKPaymentQueue.default()

}

extension RoAIAPManager: RoAIAPManagerProtocol {
   
    public func updateProductsStatus() {
        productsVerificator?.updateProductsStatus(productsIDs, complition: { avalableProducts in
            avalableProducts.forEach {
                self.productsStatment?.saveInAppStatus($0, isAvailable: true)
            }
        })
    }
    
    public func isProductsAvalable(productsId: String) -> Bool? {
       return productsStatment?.isAvalable(product: productsId)
    }
    
    public func isHaveSubscribtion(subIDs: [String]) -> Bool? {
        let newArray = subIDs.filter {(productsStatment?.isAvalable(product: $0) ?? false)}
        guard newArray.isEmpty else {
            return true
        }
        return false
    }
    
    
    public func isIAPServrAvalable (callback: @escaping(Bool)->()) {
        if SKPaymentQueue.canMakePayments() {
            paymentQueue.add(self)
            callback(true)
            return
        }
        callback(false)
        return
    }
    
    public func getProductsFromServer() {
        guard let productsIDs = productsIDs else {return}
        let productRequest = SKProductsRequest(productIdentifiers: productsIDs)
        productRequest.delegate = self
        productRequest.start()
    }
    
    public func purchased(_ productWithidentifier: String) {
        guard let product = products?.filter({ $0.productIdentifier == productWithidentifier }).first else {return}
        let payment = SKPayment(product: product)
        paymentQueue.add(payment)
        testingPrint("Add product in paymentQueue with id: \(payment.productIdentifier)")
    }
    
    public func purchased(_ index: Int) {
        guard let product = products?[index] else {return}
        let payment = SKPayment(product: product)
        paymentQueue.add(payment)
        testingPrint("Add product in paymentQueue with id: \(payment.productIdentifier)")
    }
    
    public func restoreProducts() {
        paymentQueue.restoreCompletedTransactions()
    }
}

extension RoAIAPManager: SKPaymentTransactionObserver {
    public func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch transaction.transactionState {
            case .deferred:
                deffered(transaction: transaction)
            case .purchasing:
                purchasing(transaction: transaction)
            case .failed:
                failed(transaction: transaction)
            case .purchased:
                completed(transaction: transaction)
            case .restored:
                if transaction == transactions.last {
                    restored(transaction: transaction)
                }
            @unknown default:
                fatalError()
            }
        }
    }
    
    private func failed(transaction: SKPaymentTransaction) {
        if let transactionError = transaction.error as NSError? {
            if transactionError.code != SKError.paymentCancelled.rawValue {
                testingPrint("Ошибка транзакции  \(transaction.error!.localizedDescription)")
            }
        }
        self.delegate?.failed(transaction: transaction)
        paymentQueue.finishTransaction(transaction)
    }
    
    private func completed(transaction: SKPaymentTransaction) {
        self.delegate?.purchased(transaction: transaction)
        testingPrint("Transaction completed")
        paymentQueue.finishTransaction(transaction)
    }
    
    private func deffered(transaction: SKPaymentTransaction) {
        self.delegate?.deferred(transaction: transaction)
        testingPrint("Transaction deffered")
        paymentQueue.finishTransaction(transaction)
    }
    
    private func purchasing(transaction: SKPaymentTransaction) {
        self.delegate?.purchasing(transaction: transaction)
        testingPrint("Transaction purchasing")
    }
    
    private func restored(transaction: SKPaymentTransaction) {
        SKPaymentQueue.default().restoreCompletedTransactions()
        self.delegate?.restored(transaction: transaction)
        testingPrint("Products restored")
        paymentQueue.finishTransaction(transaction)
    }
}

extension RoAIAPManager: SKProductsRequestDelegate {
    
    public func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        self.products = response.products
        products?.forEach { testingPrint("Got products: \($0.localizedTitle)")}
        guard response.invalidProductIdentifiers.isEmpty else {
            return  testingPrint("Invalid Product Identifiers: \(response.invalidProductIdentifiers)")
        }
    }
    
    public func requestDidFinish(_ request: SKRequest) {
        delegate?.productRequestDidFinished()
    }
}

extension SKProduct {
  
    /// - returns: The cost of the product formatted in the local currency.
    
    var regularPrice: String? {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = self.priceLocale
        return formatter.string(from: self.price)
    }
}

