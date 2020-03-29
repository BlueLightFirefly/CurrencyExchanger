//
//  CurrencyListViewModel.swift
//  CurrencyExchanger
//
//  Created by Katerina Kostritsyna on 28.03.2020.
//  Copyright © 2020 Katerina Kostritsyna. All rights reserved.
//

import Foundation
import RxSwift
class CurrencyListViewModel {
    
    var resultsObservervable: Observable<[Currency]> {
        return results.asObservable().catchErrorJustReturn([]).observeOn(MainScheduler.instance)
    }
    
    var resultsThrowableObservervable: Observable<[Currency]> {
        return results.asObservable().observeOn(MainScheduler.instance)
    }
    
    var results = BehaviorSubject(value: [Currency]())
    var allCurrencies = [Currency]()
    private let networkManager =  NetworkManager()
    private var disposeBag = DisposeBag()
    var filter: String = "" {
        didSet {
            if (filter.isEmpty) {
                results.onNext(allCurrencies)
            } else {
                let filteredResults = allCurrencies.filter({ $0.currencyName.contains(filter) ||
                    $0.id.contains(filter) ||
                    ($0.currencySymbol?.contains(filter)) ?? false })
                results.onNext(filteredResults)
            }
        }
    }
    
    var currencyObserver: BehaviorSubject<Currency?>?
    
    func loadCurrencies() {
        networkManager.requestAllCurrencies()
            .subscribe(onNext: { [weak self] currenciesArray in
                let sortedCurrencies = currenciesArray.sorted(by:{$0.currencyName < $1.currencyName})
                self?.allCurrencies = sortedCurrencies
                self?.results
                    .onNext(sortedCurrencies)
                }, onError: { [weak self] e in
                    self?.results.onError(e)
            }).disposed(by: disposeBag)
    }
    
    func selected(currency: Currency) {
        currencyObserver?.onNext(currency)
    }
    
}
