//
//  CurrencyView.swift
//  CurrencyExchanger
//
//  Created by Katerina Kostritsyna on 28.03.2020.
//  Copyright © 2020 Katerina Kostritsyna. All rights reserved.
//

import UIKit
import Foundation
class CurrencyView: UIView {
    
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
