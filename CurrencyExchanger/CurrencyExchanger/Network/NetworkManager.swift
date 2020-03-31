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

private let APIKey = "f96847c424msh3226f07e3f2ade4p1464a8jsn93f99a3b39e5"
private let APIHost = "currency-converter5.p.rapidapi.com"

class NetworkManager {
    private var disposeBag = DisposeBag()
    func requestAllCurrencies() -> Observable<[Currency]> {
        return Observable<[Currency]>.create { [weak self] observer in
            guard let strongSelf = self else { return Disposables.create() }
            let requestURL = URL(string:"https://currency-converter5.p.rapidapi.com/currency/list")!
            var request = URLRequest(url: requestURL)
            request.httpMethod = "GET"
            request.addValue(APIKey, forHTTPHeaderField: "x-rapidapi-key")
            request.addValue(APIHost, forHTTPHeaderField: "x-rapidapi-host")
            RxAlamofire.requestData(request)
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
                })
                .disposed(by: strongSelf.disposeBag)
        }
        return Disposables.create()
    }
    
    func exchange(from: Currency, to: Currency, amount: String) -> Observable<ConvertationValue> {
        return Observable<ConvertationValue>.create { [weak self] observer in
            guard let strongSelf = self else { return Disposables.create() }
            let requestURL = URL(string:"https://currency-converter5.p.rapidapi.com/currency/convert?from=\(from.currencySymbol)&to=\(to.currencySymbol)&amount=\(amount)")!
            var request = URLRequest(url: requestURL)
            request.httpMethod = "GET"
            request.addValue(APIKey, forHTTPHeaderField: "x-rapidapi-key")
            request.addValue(APIHost, forHTTPHeaderField: "x-rapidapi-host")
            RxAlamofire.requestData(request)
                .subscribe(onNext: { responce, data in
                    do {
                        let result = try JSONDecoder().decode(ConvertationResult.self, from: data)
                        observer.onNext(result.value)
                        observer.onCompleted()
                    } catch let e {
                        observer.onError(e)
                    }
                }, onError: { error in
                    observer.onError(error)
                })
                .disposed(by: strongSelf.disposeBag)
            return Disposables.create()
        }
    }
}
