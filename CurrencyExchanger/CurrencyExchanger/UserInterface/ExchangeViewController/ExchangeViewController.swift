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
    
    //MARK: - life cycle
    
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
    
    //MARK: - actions
    
    @IBAction func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    @IBAction func exchangeButtonTapped() {
        let result = viewModel.canSendRequest()
        if result == .allValid {
            //todo: Send request
        } else {
            showValidationMessage(result)
        }
    }
    
    private func showValidationMessage(_ result: ValidationResult) {
        self.show(errorMessage: validationMessage(for: result), title: nil)
    }
    
    private func validationMessage(for state: ValidationResult) -> String {
        switch (state) {
        case .firstCurrencyEmpty:
            return NSLocalizedString("First currency value is empty. Please select any one", comment: "ExchangeViewController: First currency not selected error message")
        case .secondCurrencyEmpty:
            return NSLocalizedString("Second currency value is empty. Please select any one", comment: "ExchangeViewController: Second currency not selected error message")
        case .firstFieldEmpty:
            return NSLocalizedString("First text field value is empty. Please enter value", comment: "ExchangeViewController: First text field is empty")
        case .secondFieldEmpty:
            return NSLocalizedString("First text field value is empty. Please enter value", comment: "ExchangeViewController: Second text field is empty")
        case .allValid:
            return ""
        }
    }
    
    private func show(errorMessage message: String?, title: String?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: NSLocalizedString("Ok", comment: "Ok alert action"), style: .default, handler:nil)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
}
