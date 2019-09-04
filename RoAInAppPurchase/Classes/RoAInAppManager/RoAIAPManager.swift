//
//  IAPManager.swift
//  WallPapers
//
//  Created by Александр Сахнюков on 04/02/2019.
//  Copyright © 2019 Александр Сахнюков. All rights reserved.
//

import StoreKit


public final class RoAIAPManager: NSObject, RoAIAPManagerProtocol {
    
    weak public var delegate: RoAIAPManagerDelegate?
    
    private(set) public var products: [SKProduct]?
    
    public var productsIDs: Set<String>
    
    private var paymentQueue = SKPaymentQueue.default()
    
    public func isIAPServrAvalable (callback: @escaping(Bool)->()) {
        if SKPaymentQueue.canMakePayments() {
            SKPaymentQueue.default().add(self)
            callback(true)
            return
        }
        callback(false)
        return
    }
    
    public func getProductsFromServer() {
        let productRequest = SKProductsRequest(productIdentifiers: productsIDs)
        productRequest.delegate = self
        productRequest.start()
    }
    
    public func purchased(_ productWithidentifier: String) {
        guard let product = products?.filter({ $0.productIdentifier == productWithidentifier }).first else {return}
        let payment = SKPayment(product: product)
        paymentQueue.add(payment)
    }
    
    public func restoreProducts() {
        paymentQueue.restoreCompletedTransactions()
    }
    
    init(_ productsIDS: Set<String>) {
        self.productsIDs = productsIDS
        super.init()
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
                print("Ошибка транзакции  \(transaction.error!.localizedDescription)")
            }
        }
        let getProduct = products?.filter {$0.productIdentifier == transaction.transactionIdentifier}.first
        guard let product = getProduct else {return}
        paymentQueue.finishTransaction(transaction)
        self.delegate?.failed(transaction: transaction, product: product)
    }
    
    private func completed(transaction: SKPaymentTransaction) {
        let getProduct = products?.filter {$0.productIdentifier == transaction.transactionIdentifier}.first
        guard let product = getProduct else {return}
        paymentQueue.finishTransaction(transaction)
        self.delegate?.purchased(transaction: transaction, product: product)
    }
    
    private func deffered(transaction: SKPaymentTransaction) {
        let getProduct = products?.filter {$0.productIdentifier == transaction.transactionIdentifier}.first
        guard let product = getProduct else {return}
        paymentQueue.finishTransaction(transaction)
        self.delegate?.deferred(transaction: transaction, product: product)
    }
    
    private func purchasing(transaction: SKPaymentTransaction) {
        let getProduct = products?.filter {$0.productIdentifier == transaction.transactionIdentifier}.first
        guard let product = getProduct else {return}
        self.delegate?.purchasing(transaction: transaction, product: product)
    }
    
    private func restored(transaction: SKPaymentTransaction) {
        let getProduct = products?.filter {$0.productIdentifier == transaction.transactionIdentifier}.first
        guard let product = getProduct else {return}
        paymentQueue.finishTransaction(transaction)
        self.delegate?.restored(transaction: transaction, product: product)
    }
}


extension RoAIAPManager: SKProductsRequestDelegate {
    public func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        self.products = response.products
        products?.forEach { print("Got products: \($0.localizedTitle)")}
        guard response.invalidProductIdentifiers.isEmpty else {
            return  print("Invalid Product Identifiers: \(response.invalidProductIdentifiers)")
        }
    }
    
    public func requestDidFinish(_ request: SKRequest) {
        delegate?.productRequestDidFinished()
    }
}

