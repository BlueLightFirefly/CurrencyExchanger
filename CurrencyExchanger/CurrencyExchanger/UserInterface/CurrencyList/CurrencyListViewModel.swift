//
//  CurrencyListViewModel.swift
//  CurrencyExchanger
//
//  Created by Katerina Kostritsyna on 28.03.2020.
//  Copyright © 2020 Katerina Kostritsyna. All rights reserved.
//

import Foundation
class CurrencyListViewModel {
    private var currensies: [Currency] = [Currency(name: "Russian Ruble", symbol:"RUB"),
                                          Currency(name: "Albanian Lek", symbol:"ALL"),
                                          Currency(name: "East Caribbean Dollar", symbol:"XCD"),
                                          Currency(name: "Euro", symbol:"EUR"),]
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
