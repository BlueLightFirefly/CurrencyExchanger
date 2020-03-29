//
//  CurrencyCell.swift
//  CurrencyExchanger
//
//  Created by Katerina Kostritsyna on 28.03.2020.
//  Copyright © 2020 Katerina Kostritsyna. All rights reserved.
//

import Foundation
import UIKit

class CurrencyCell: UITableViewCell {
    @IBOutlet var currencyTitle: UILabel!
    @IBOutlet var currencySymbol: UILabel!
    var currency: Currency? {
        didSet {
            if let value = currency {
                currencyTitle.text = value.currencyName
                currencySymbol.text = value.currencySymbol
            }
        }
    }
}
