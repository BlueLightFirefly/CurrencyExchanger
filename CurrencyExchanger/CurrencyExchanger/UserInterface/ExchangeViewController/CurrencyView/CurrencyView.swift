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
    class func instanceFromNib() -> CurrencyView {
        return UINib(nibName: "CurrencyView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! CurrencyView
    }
    
    @IBAction func currencyButtonTapped() {
        print("Tapped")
    }
}
