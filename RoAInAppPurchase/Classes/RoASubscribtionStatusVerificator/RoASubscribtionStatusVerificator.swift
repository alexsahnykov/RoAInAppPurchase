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
    
    
    public func updateProductsStatus(_ products: Set<String>?, complition: @escaping(_ avalableProducts: [String]) -> Void) {
        guard let products = products else { return complition([])}
        let urlRequest = createRequestForValidation()
        guard let request = urlRequest else {return}
        URLSession.shared.dataTask(with: request)  { (data, response, error) in
            DispatchQueue.main.async {
                if let data = data {
                    if let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments){
                        var avalableProductsArray:[String] = []
                        for productsID in products {
                            if self.checkNonSubProduct(productsID, json: json as! Dictionary<String, Any>) || self.checkSubProduct(productsID, json: json as! Dictionary<String, Any>) {
                                avalableProductsArray.append(productsID)
                            }
                            return
                        }
                        complition(avalableProductsArray)
                    }
                } else {
                    testingPrint("error validating receipt: \(error?.localizedDescription ?? "Unexpected error")")
                }
            }
            }.resume()
    }
    
    private func checkNonSubProduct(_ id: String, json: Dictionary<String, Any>) -> Bool {
        guard let receipts_array = json["latest_receipt_info"] as? [Dictionary<String, Any>] else {
            testingPrint("No avalable subscribtion receipt")
            return (false)
        }
        for receipt in receipts_array {
            guard  id == receipt["product_id"] as? String else {return false}
            if receipt["expires_date"] as? String == nil {
                return true
            } else {
                return false
            }
        }
        return false
    }
    
    private func checkSubProduct(_ id: String, json: Dictionary<String, Any> ) -> Bool {
        guard let receipts_array = json["latest_receipt_info"] as? [Dictionary<String, Any>] else {
             testingPrint("No avalable subscribtion receipt")
             return (false)
         }
        for receipt in receipts_array {
                if let exspireDate = dateFormater.date(from: receipt["expires_date"] as! String),
                    let startedDate = dateFormater.date(from: receipt["original_purchase_date"] as! String) {
                    let currientDate = Date.getTodayRounded()
                    if exspireDate > currientDate {
                        testingPrint("Subscribtion is avalable, started at \(startedDate),  today \(currientDate) and expired at \(exspireDate)")
                        return true
                    } else {
                        testingPrint("Subscribtion is unavalable, started at \(startedDate), today \(currientDate) and expired at \(exspireDate)")
                        return false
                    }
                }
            }
            return false
    }
    
    
    public init(_ secret: String) {
        self.sharedSecret = secret
    }
        
}

extension Date {
   
    public static func getTodayRounded() -> Date {
        let now = Date()
        
        let gregorian = Calendar(identifier: .gregorian)
        
        let dateComponents = gregorian.dateComponents([.year, .month, .day, .hour, .minute, .second], from: now)
        let dateWithSelectedComponents = gregorian.date(from: dateComponents)!
        
        return dateWithSelectedComponents
    }
    
   public func toISOString(formatter: DateFormatter) -> String {
        return formatter.string(from: self)
    }
}
