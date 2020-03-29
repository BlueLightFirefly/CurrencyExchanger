//
//  NetworkManager.swift
//  CurrencyExchanger
//
//  Created by Katerina Kostritsyna on 29.03.2020.
//  Copyright © 2020 Katerina Kostritsyna. All rights reserved.
//

import Foundation
import RxAlamofire
import RxSwift

class NetworkManager {
    private var disposeBag = DisposeBag()
    func requestAllCurrencies() -> Observable<[Currency]> {
        return Observable<[Currency]>.create {[weak self] observer in
            if let strongSelf = self {
            let requestURL = URL(string:"https://free.currconv.com/api/v7/currencies?apiKey=do-not-use-this-key")!
            RxAlamofire.requestData(.get, requestURL)
                .debug()
                .subscribe(onNext: { responce, data in
                    do {
                        let currencies = try JSONDecoder().decode(Currencies.self, from: data)
                        observer.onNext(currencies.asArray)
                        observer.onCompleted()
                    } catch let e {
                        observer.onError(e)
                    }
                }, onError: { error in
                    observer.onError(error)
                }).disposed(by: strongSelf.disposeBag)
            }
            return Disposables.create()
            
        }
        
    }
}
