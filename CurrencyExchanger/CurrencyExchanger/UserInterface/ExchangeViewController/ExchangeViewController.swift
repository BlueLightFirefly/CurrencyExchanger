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
    @IBOutlet var exchangeButton: LoadingButton!
    @IBOutlet var firstCurrencyTextField: UITextField!
    @IBOutlet var secondCurrencyTextField: UITextField!
    
    private let viewModel = ExchangeViewModel()
    private let disposeBag = DisposeBag()
    
    private var lastActiveTextField: UITextField?
    
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
        
        viewModel.firstFieldAmount.bind(to: firstCurrencyTextField.rx.text).disposed(by: self.disposeBag)
        firstCurrencyTextField.rx.text.orEmpty.bind(to: viewModel.firstFieldAmount).disposed(by: self.disposeBag)
        
        viewModel.secondFieldAmount.bind(to: secondCurrencyTextField.rx.text).disposed(by: self.disposeBag)
        secondCurrencyTextField.rx.text.orEmpty.bind(to: viewModel.secondFieldAmount).disposed(by: self.disposeBag)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    //todo: make channels with Rx
    //todo: refactor to use one callback and observer inside
    private func firstFieldCurrencyChange() {
        showCurrencySelector(observer: viewModel.firstCurrency)
    }
    
    private func secondFieldCurrencyChange() {
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
        dismissKeyboard()
        let result = viewModel.canSendRequest()
        if result == .allValid {
            viewModel.exchange(isFirstValue: lastActiveTextField == firstCurrencyTextField)
                .subscribe(onNext: { [weak self] value in
                    self?.exchangeButton.isLoading = value
                    }, onError: {[weak self] error in
                        self?.show(errorMessage: error.localizedDescription, title: nil)
                })
                .disposed(by: self.disposeBag)
        } else {
            showValidationMessage(result)
        }
    }
    
    @IBAction func textFieldBecomeActive(sender: UITextField) {
        lastActiveTextField = sender
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
