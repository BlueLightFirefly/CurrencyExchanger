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
    var currencyObservable: Observable<Currency?>? {
        didSet {
            currencyObservable?.observeOn(MainScheduler.instance)
                .subscribe(onNext: { [weak self] currency in
                    self?.currencyLabel.text = currency?.currencySymbol ?? currency?.id ?? ""
                })
                .disposed(by: disposableBag)
        }
    }
    var currencyChangeTapBlock: (()-> ())?
    class func instanceFromNib(tapBlock:(()-> ())? = nil) -> CurrencyView {
        let view = UINib(nibName: "CurrencyView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! CurrencyView
        view.currencyChangeTapBlock = tapBlock
        return view
    }
    
    @IBAction func currencyButtonTapped() {
        print("Tapped")
        currencyChangeTapBlock?()
    }
}
