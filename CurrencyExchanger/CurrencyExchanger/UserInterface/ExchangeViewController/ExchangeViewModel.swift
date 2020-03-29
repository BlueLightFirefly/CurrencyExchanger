//
//  ExchangeViewModel.swift
//  CurrencyExchanger
//
//  Created by Katerina Kostritsyna on 28.03.2020.
//  Copyright © 2020 Katerina Kostritsyna. All rights reserved.
//

import Foundation
import RxSwift

class ExchangeViewModel {
    private var firstCurrencyValue: Currency?
    private var secondCurrencyValue: Currency?
    
    let firstCurrency = BehaviorSubject<Currency?>(value: nil)
    let secondCurrency = BehaviorSubject<Currency?>(value: nil)
    
    
}
