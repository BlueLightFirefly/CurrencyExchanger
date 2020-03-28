//
//  exchangeViewController.swift
//  CurrencyExchanger
//
//  Created by Katerina Kostritsyna on 28.03.2020.
//  Copyright © 2020 Katerina Kostritsyna. All rights reserved.
//

import Foundation
import UIKit

class ExchangeViewController: UIViewController {
    @IBOutlet var exchangeButton: UIButton!
    @IBOutlet var firstCurrencyTextField: UITextField!
    @IBOutlet var secondCurrencyTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        exchangeButton.layer.cornerRadius = 4
        firstCurrencyTextField.rightViewMode = UITextField.ViewMode.always
        firstCurrencyTextField.rightView = CurrencyView.instanceFromNib()
        secondCurrencyTextField.rightViewMode = UITextField.ViewMode.always
        secondCurrencyTextField.rightView = CurrencyView.instanceFromNib()
    }
    
    @IBAction func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
}
