//
//  SubscribtionStatusVerificator.swift
//  Horoscope
//
//  Created by Александр Сахнюков on 16/07/2019.
//  Copyright © 2019 Александр Сахнюков. All rights reserved.
//

import Foundation
import StoreKit

public class RoACustomStatusVerificator: RoAProductsVerificatorProtocol {
    
    private var sharedSecret: String
    
    private var dateFormater: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd HH:mm:ss VV"
        df.timeZone = TimeZone(secondsFromGMT: 0)
        return df
    }()
    
    private enum VerifyReceiptURL: String {
        case debug = "https://sandbox.itunes.apple.com/verifyReceipt"
        case production = "https://buy.itunes.apple.com/verifyReceipt"
        
        func getURL() -> URL {
            switch self {
            case .debug:
                return URL(string: VerifyReceiptURL.debug.rawValue)!
            case .production:
                return URL(string: VerifyReceiptURL.production.rawValue)!
            }
        }
    }
    
    private func createRequestForValidation() -> URLRequest? {
        guard let receiptUrl = Bundle.main.appStoreReceiptURL else {
            testingPrint("No avalable receipts")
            return nil
        }
        #if DEBUG
        let urlString = VerifyReceiptURL.getURL(.debug)
        #else
        let urlString = VerifyReceiptURL.getURL(.production)
        #endif
        let receiptData = try? Data(contentsOf: receiptUrl).base64EncodedString()
        let requestData = ["receipt-data" : receiptData ?? "", "password" : self.sharedSecret, "exclude-old-transactions" : true] as [String : Any]
        var request = URLRequest(url: urlString())
        request.httpMethod = "POST"
        request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
        let httpBody = try? JSONSerialization.data(withJSONObject: requestData, options: [])
        request.httpBody = httpBody
        return request
    }
    
    
    public func getSubscribtionStatus(_ complition: @escaping(RoASubscribtionStatus, _ latestProduct: String?) -> Void) {
        let urlRequest = createRequestForValidation()
        guard let request = urlRequest else {return}
        URLSession.shared.dataTask(with: request)  { (data, response, error) in
            DispatchQueue.main.async {
                if let data = data {
                    if let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments){
                        let subStatus = self.parseReceiptForSubscribtion(json as! Dictionary<String, Any>)
                        complition(subStatus.0, subStatus.1)
                        return
                    }
                } else {
                    testingPrint("error validating receipt: \(error?.localizedDescription ?? "Unexpected error")")
                }
            }
            }.resume()
    }
    
    public func getNonConsumableProductStatus(productID: String, _ complition: @escaping(RoASubscribtionStatus, _ latestProduct: String?) -> Void) {
        let urlRequest = createRequestForValidation()
        guard let request = urlRequest else {return}
        URLSession.shared.dataTask(with: request)  { (data, response, error) in
            DispatchQueue.main.async {
                if let data = data {
                    if let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments){
                        let subStatus = self.parseReceiptForNonConsumableProduct(json as! Dictionary<String, Any>, productID: productID)
                        complition(subStatus.0, subStatus.1)
                        return
                    }
                } else {
                    testingPrint("error validating receipt: \(error?.localizedDescription ?? "")")
                }
            }
            }.resume()
    }
    
    private func parseReceiptForSubscribtion(_ json : Dictionary<String, Any>) -> (RoASubscribtionStatus, String?) {
        guard let receipts_array = json["latest_receipt_info"] as? [Dictionary<String, Any>] else {
            testingPrint("No avalable subscribtion receipt")
            return (.unavalable, nil)
        }
        for receipt in receipts_array {
            let productID = receipt["product_id"] as! String
            if let exspireDate = dateFormater.date(from: receipt["expires_date"] as! String),
                let startedDate = dateFormater.date(from: receipt["original_purchase_date"] as! String) {
                let currientDate = Date.getTodayRounded()
                if exspireDate > currientDate {
                    testingPrint("Subscribtion is avalable, started at \(startedDate),  today \(currientDate) and expired at \(exspireDate)")
                    return (.avalable, productID)
                } else {
                    testingPrint("Subscribtion is unavalable, started at \(startedDate), today \(currientDate) and expired at \(exspireDate)")
                    return (.unavalable, productID)
                }
            }
        }
        return (.unavalable, nil)
    }
    
    private func parseReceiptForNonConsumableProduct(_ json : Dictionary<String, Any>, productID: String) -> (RoASubscribtionStatus, String?) {
        guard let receipts_array = json["latest_receipt_info"] as? [Dictionary<String, Any>] else {
            testingPrint("No avalable products receipt")
            return (.unavalable, nil)
        }
        for receipt in receipts_array {
            let productIDInReceipt = receipt["product_id"] as! String
            guard productID == productIDInReceipt else {
                return (.unavalable, productID)
            }
            return (.avalable, productID)
        }
             return (.unavalable, nil)
    }
        
        
        
        public init(_ secret: String) {
            self.sharedSecret = secret
        }
        
        
}
