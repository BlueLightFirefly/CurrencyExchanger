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
        firstCurrencyTextField.rightView = CurrencyView.instanceFromNib(tapBlock: firstFieldCurrencyChange)
        secondCurrencyTextField.rightViewMode = UITextField.ViewMode.always
        secondCurrencyTextField.rightView = CurrencyView.instanceFromNib(tapBlock: secondFieldCurrencyChange)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    //todo: make channels with Rx
    private func firstFieldCurrencyChange() {
        print("first field tap")
        showCurrencySelector()
    }
    
    private func secondFieldCurrencyChange() {
        print("second field tap")
        showCurrencySelector()
    }
    
    private func showCurrencySelector() {
        let vc = CurrencyListViewController.fromStoryboard()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
}
