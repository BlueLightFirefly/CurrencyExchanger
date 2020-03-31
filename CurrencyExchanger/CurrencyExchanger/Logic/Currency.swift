//
//  Currency.swift
//  CurrencyExchanger
//
//  Created by Katerina Kostritsyna on 29.03.2020.
//  Copyright © 2020 Katerina Kostritsyna. All rights reserved.
//

import Foundation
struct Currency: Decodable {
    var currencyName: String
    var currencySymbol: String
}

struct Currencies : Decodable {
    var currencies : [String : String]
    var asArray : [Currency] {
        get {
            var array = [Currency]()
            currencies.forEach { elem in
                let currency = Currency(currencyName: elem.value, currencySymbol: elem.key)
                array.append(currency)
            }
            return array
        }
    }
}

struct ConvertationValue: Decodable {
    var rate_for_amount: String
}

struct ConvertationResult: Decodable {
    var rates: [String: ConvertationValue]
    var value: ConvertationValue {
        return rates.first!.value
    }
}

