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
    private var currensies: [Currency] = [Currency(id:"", currencyName: "Russian Ruble", currencySymbol:"RUB"),
                                          Currency(id:"",currencyName: "Albanian Lek", currencySymbol:"ALL"),
                                          Currency(id:"",currencyName: "East Caribbean Dollar", currencySymbol:"XCD"),
                                          Currency(id:"",currencyName: "Euro", currencySymbol:"EUR"),]
    
    var resultsObservervable: Observable<[Currency]> {
        return results.asObservable().observeOn(MainScheduler.instance)
    }
    
    var results = BehaviorSubject(value: [Currency]())
    private let networkManager =  NetworkManager()
    private var disposeBag = DisposeBag()
    
    func loadCurrencies() {
        networkManager.requestAllCurrencies()
            .subscribe(onNext: { [weak self] currenciesArray in
                self?.results.onNext(currenciesArray.sorted(by:{$0.currencyName < $1.currencyName}))
                }, onError: { [weak self] e in
                    self?.results.onError(e)
            }).disposed(by: disposeBag)
        
    }
    
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
