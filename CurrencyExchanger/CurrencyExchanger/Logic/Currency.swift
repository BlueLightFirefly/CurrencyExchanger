//
//  Currency.swift
//  CurrencyExchanger
//
//  Created by Katerina Kostritsyna on 29.03.2020.
//  Copyright © 2020 Katerina Kostritsyna. All rights reserved.
//

import Foundation
struct Currency: Decodable {
    var id: String
    var currencyName: String
    var currencySymbol: String?
}

struct Currencies : Decodable {
    var results : [String : Currency]
    
    var asArray : [Currency] {
        get {
            var array = [Currency]()
            results.forEach { elem in
                array.append(elem.value)
            }
            return array
        }
    }
}
