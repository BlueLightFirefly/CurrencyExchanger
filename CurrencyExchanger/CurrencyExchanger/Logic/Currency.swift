//
//  Currency.swift
//  CurrencyExchanger
//
//  Created by Katerina Kostritsyna on 29.03.2020.
//  Copyright © 2020 Katerina Kostritsyna. All rights reserved.
//

import Foundation
struct Currency: Decodable {
    let currencyName: String
    let currencySymbol: String
}

struct Currencies : Decodable {
    let currencies : [String : String]
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
    let rate_for_amount: String
}

struct ConvertationResult: Decodable {
    let rates: [String: ConvertationValue]
    var value: ConvertationValue {
        return rates.first!.value
    }
}

