//
//  exchangeViewController.swift
//  CurrencyExchanger
//
//  Created by Katerina Kostritsyna on 28.03.2020.
//  Copyright © 2020 Katerina Kostritsyna. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

class ExchangeViewController: UIViewController {
    @IBOutlet var exchangeButton: UIButton!
    @IBOutlet var firstCurrencyTextField: UITextField!
    @IBOutlet var secondCurrencyTextField: UITextField!
    
    private let viewModel = ExchangeViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        exchangeButton.layer.cornerRadius = 4
        setupTextFields()
    }
    
    private func setupTextFields() {
        let firstRightView = CurrencyView.instanceFromNib(tapBlock: firstFieldCurrencyChange)
        firstRightView.currencyObservable = viewModel.firstCurrency.asObservable()
        firstCurrencyTextField.rightViewMode = UITextField.ViewMode.always
        firstCurrencyTextField.rightView = firstRightView
        let secondRightView = CurrencyView.instanceFromNib(tapBlock: secondFieldCurrencyChange)
        secondRightView.currencyObservable = viewModel.secondCurrency.asObservable()
        secondCurrencyTextField.rightViewMode = UITextField.ViewMode.always
        secondCurrencyTextField.rightView = secondRightView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    //todo: make channels with Rx
    //todo: refactor to use one callback and observer inside
    private func firstFieldCurrencyChange() {
        print("first field tap")
        showCurrencySelector(observer: viewModel.firstCurrency)
    }
    
    private func secondFieldCurrencyChange() {
        print("second field tap")
        showCurrencySelector(observer: viewModel.secondCurrency)
    }
    
    private func showCurrencySelector(observer: BehaviorSubject<Currency?>) {
        let vc = CurrencyListViewController.fromStoryboard()
        vc.viewModel.currencyObserver = observer
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
}
