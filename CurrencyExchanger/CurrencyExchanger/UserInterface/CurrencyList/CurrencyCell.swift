//
//  CurrencyCell.swift
//  CurrencyExchanger
//
//  Created by Katerina Kostritsyna on 28.03.2020.
//  Copyright © 2020 Katerina Kostritsyna. All rights reserved.
//

import Foundation
import UIKit

struct Currency {
    var name: String
    var symbol: String
}

class CurrencyCell: UITableViewCell {
    @IBOutlet var currencyTitle: UILabel!
    @IBOutlet var currencySymbol: UILabel!
    var currency: Currency? {
        didSet {
            if let value = currency {
                currencyTitle.text = value.name
                currencySymbol.text = value.symbol
            }
        }
    }
}
