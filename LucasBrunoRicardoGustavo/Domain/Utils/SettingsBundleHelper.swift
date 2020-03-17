//
//  SettingsBundleHelper.swift
//  LucasBrunoRicardoGustavo
//
//  Created by Lucas Barcelos on 16/03/20.
//  Copyright © 2020 Lucas Barcelos. All rights reserved.
//

import Foundation
class SettingsBundleHelper {
    struct SettingsBundleKeys {
        static let IOFTaxValue = "IOF"
        static let DollarExchangeRate = "Dolar"
    }
    
    class func setDefaultValueDollarAndIOF() {
        UserDefaults.standard.set("6.38", forKey: "IOF")
        UserDefaults.standard.set("4.80", forKey: "Dolar")
    }
    
    class func getSettingsBundleValues(identifier: String) -> String? {
        let defaults = UserDefaults.standard
        let value = defaults.string(forKey: identifier)
        return value
    }
    
    class func setApplicationDefault(defaultKey: String, value: String) {
        let defaults = UserDefaults.standard
        defaults.set(value, forKey: defaultKey)
    }
}

