//
//  Date.swift
//  Pods-RoAInAppPurchase_Tests
//
//  Created by Александр Сахнюков on 21/08/2019.
//

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
