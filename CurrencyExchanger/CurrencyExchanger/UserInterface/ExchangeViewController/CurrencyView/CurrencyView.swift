//
//  CurrencyView.swift
//  CurrencyExchanger
//
//  Created by Katerina Kostritsyna on 28.03.2020.
//  Copyright © 2020 Katerina Kostritsyna. All rights reserved.
//

import UIKit
import Foundation
import RxSwift

class CurrencyView: UIView {
    @IBOutlet var currencyLabel: UILabel!
    let disposableBag = DisposeBag()
    private var valueObserver: BehaviorSubject<Currency?>?
    var currencyObservable: Observable<Currency?>? {
        didSet {
            currencyObservable?.observeOn(MainScheduler.instance)
                .subscribe(onNext: { [weak self] currency in
                    self?.currencyLabel.text = currency?.currencySymbol ?? ""
                })
                .disposed(by: disposableBag)
        }
    }
    var currencyChangeTapBlock: ((BehaviorSubject<Currency?>)-> ())?
    class func instanceFromNib(tapBlock:((BehaviorSubject<Currency?>)-> ())? = nil, observer: BehaviorSubject<Currency?>) -> CurrencyView {
        let view = UINib(nibName: "CurrencyView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! CurrencyView
        view.currencyChangeTapBlock = tapBlock
        view.valueObserver = observer
        return view
    }
    
    @IBAction func currencyButtonTapped() {
        if let valueObserver = valueObserver {
        currencyChangeTapBlock?(valueObserver)
        }
    }
}
