//
//  CurrencyListViewModel.swift
//  CurrencyExchanger
//
//  Created by Katerina Kostritsyna on 28.03.2020.
//  Copyright © 2020 Katerina Kostritsyna. All rights reserved.
//

import Foundation
class CurrencyListViewModel {
    private var currensies: [Currency] = [Currency(id:"", currencyName: "Russian Ruble", currencySymbol:"RUB"),
                                          Currency(id:"",currencyName: "Albanian Lek", currencySymbol:"ALL"),
                                          Currency(id:"",currencyName: "East Caribbean Dollar", currencySymbol:"XCD"),
                                          Currency(id:"",currencyName: "Euro", currencySymbol:"EUR"),]
    func numberOfSections() -> Int {
        return 1
    }
    
    func numberOfRows(in section: Int) -> Int {
        return currensies.count
    }
    
    func currency(for indexPath: IndexPath) -> Currency {
        return currensies[indexPath.row]
    }
}
