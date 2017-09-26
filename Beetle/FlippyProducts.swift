//
//  FlippyProducts.swift
//  FlippysFlight
//
//  Created by Dori Mouawad on 9/21/17.
//  Copyright © 2017 Muskan. All rights reserved.
//

import Foundation

public struct FlippyProducts {
    
    //Purchase twenty
    public static let purchaseTwenty = "com.flippysflight.purchasefive"
    
    //Purchase one hundred
    public static let purchaseOneHundredTen = "com.flippysflight.purchasethirty"
    
    //Purchase three hundred
    public static let purchaseThreeHundred = "com.flippysflight.purchaseseventyfive"
    
    //Purchase one thousand
    public static let purchaseOneThousand = "com.flippysflight.purchasetwohundred"
    
    //Set product identifiers
    fileprivate static let productIdentifiers: Set<ProductIdentifier> = [FlippyProducts.purchaseTwenty,
                                                                         FlippyProducts.purchaseOneHundredTen,
                                                                         FlippyProducts.purchaseThreeHundred,
                                                                         FlippyProducts.purchaseOneThousand]
    
    //Set store variable
    public static let store = IAPHelper(productIds: FlippyProducts.productIdentifiers)
}

func resourceNameForProductIdentifier(_ productIdentifier: String) -> String? {
    return productIdentifier.components(separatedBy: ".").last
}
