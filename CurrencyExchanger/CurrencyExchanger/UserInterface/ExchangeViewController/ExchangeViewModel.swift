//
//  ExchangeViewModel.swift
//  CurrencyExchanger
//
//  Created by Katerina Kostritsyna on 28.03.2020.
//  Copyright © 2020 Katerina Kostritsyna. All rights reserved.
//

import Foundation
import RxSwift

enum ValidationResult {
    case firstCurrencyEmpty
    case secondCurrencyEmpty
    case firstFieldEmpty
    case secondFieldEmpty
    case allValid
}

class ExchangeViewModel {
    private var firstCurrencyValue: Currency?
    private var secondCurrencyValue: Currency?
    
    let firstCurrency = BehaviorSubject<Currency?>(value: nil)
    let secondCurrency = BehaviorSubject<Currency?>(value: nil)
    let firstFieldValue = BehaviorSubject(value: "")
    let secondFieldValue = BehaviorSubject(value: "")
    private let disposeBag = DisposeBag()
    init() {
        firstCurrency
            .subscribe(onNext: { [weak self] currency in
                self?.firstCurrencyValue = currency
            })
            .disposed(by: disposeBag)
        secondCurrency
            .subscribe(onNext: { [weak self] currency in
                self?.secondCurrencyValue = currency
            })
            .disposed(by:disposeBag)
    }
    
    func canSendRequest() -> ValidationResult {
        if firstCurrencyValue == nil {
            return .firstCurrencyEmpty
        }
        if secondCurrencyValue == nil {
            return .secondCurrencyEmpty
        }
        if (try? firstFieldValue.value().isEmpty) ?? true {
            return .firstFieldEmpty
        }
        if (try? secondFieldValue.value().isEmpty) ?? true {
            return .secondFieldEmpty
        }
        return .allValid
    }
    
    
}
