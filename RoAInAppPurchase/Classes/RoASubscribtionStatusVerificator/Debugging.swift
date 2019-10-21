//
//  Debugging.swift
//  Pods-RoAInAppPurchase_Tests
//
//  Created by Александр Сахнюков on 15.10.2019.
//

public func testingPrint(_ object: Any) {
    #if DEBUG
    print("[RoAInAppPurchase] + \(object)")
    #endif
}
