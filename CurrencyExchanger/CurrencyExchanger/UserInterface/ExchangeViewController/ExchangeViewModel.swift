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
    
    private var firstFieldAmountValue: String = ""
    private var secondFieldAmountValue: String = ""
    
    let firstCurrency = BehaviorSubject<Currency?>(value: nil)
    let secondCurrency = BehaviorSubject<Currency?>(value: nil)
    let firstFieldAmount = BehaviorSubject(value: "")
    let secondFieldAmount = BehaviorSubject(value: "")
    
    private let networkManager = NetworkManager()
    
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
        firstFieldAmount
            .subscribe(onNext: { [weak self] value in
                self?.firstFieldAmountValue = value
            })
            .disposed(by:disposeBag)
        secondFieldAmount
            .subscribe(onNext: { [weak self] value in
                self?.secondFieldAmountValue = value
            })
            .disposed(by:disposeBag)
        
    }
    
    func canSendRequest(isFirstValue: Bool?) -> ValidationResult {
        if firstCurrencyValue == nil {
            return .firstCurrencyEmpty
        }
        if secondCurrencyValue == nil {
            return .secondCurrencyEmpty
        }
        if let isFirstValue = isFirstValue {
            if (try? firstFieldAmount.value().isEmpty) ?? true && isFirstValue{
                return .firstFieldEmpty
            }
            if (try? secondFieldAmount.value().isEmpty) ?? true && !isFirstValue {
                return .secondFieldEmpty
            }
        } else {
            return .firstFieldEmpty
        }
        
        return .allValid
    }
    
    func exchange(isFirstValue: Bool) -> Observable<Bool> {
        let fromCurrency = isFirstValue ?  firstCurrencyValue! : secondCurrencyValue!
        let toCurrency = isFirstValue ? secondCurrencyValue! : firstCurrencyValue!
        let amount = isFirstValue ? firstFieldAmountValue : secondFieldAmountValue
        return Observable<Bool>.create({ [weak self] observer in
            observer.onNext(true)
            self?.networkManager.exchange(from: fromCurrency, to: toCurrency, amount: amount).subscribe(onNext:{value in
                isFirstValue ? self?.secondFieldAmount.onNext(value.rate_for_amount) : self?.firstFieldAmount.onNext(value.rate_for_amount)
                observer.onNext(false)
                observer.onCompleted()
            }, onError:{e in
                observer.onError(e)
            }
            ).disposed(by: self!.disposeBag)
            return Disposables.create()
        })
    }
    
    
}
