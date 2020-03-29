//
//  CurrencyListViewController.swift
//  CurrencyExchanger
//
//  Created by Katerina Kostritsyna on 28.03.2020.
//  Copyright © 2020 Katerina Kostritsyna. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class CurrencyListViewController: UIViewController {
    @IBOutlet var tableView: UITableView!
    @IBOutlet var loadingView: UIView!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    @IBOutlet var noResultsLabel: UILabel!
    
    private let viewModel: CurrencyListViewModel = CurrencyListViewModel()
    private var networkManager = NetworkManager()
    private var disposeBag = DisposeBag()
    
    class func fromStoryboard() -> CurrencyListViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "CurrencyListViewController") as! CurrencyListViewController
        return controller
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.isHidden = true
        viewModel.loadCurrencies()
        setupSubscriptions()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }
    private func setupSubscriptions() {
        viewModel
            .resultsObservervable
            .bind(to: tableView.rx.items(cellIdentifier: "CurrencyCell")) { (index, currency: Currency, cell) in
                if let currencyCell = cell as? CurrencyCell {
                    currencyCell.currency = currency
                }
        }
        .disposed(by: disposeBag)
        viewModel.resultsThrowableObservervable
            .subscribe(onNext: { [weak self] currencies in
                if (currencies.count > 0) {
                    self?.tableView.isHidden = false
                }
                }, onError: { [weak self]e in
                    self?.activityIndicator.stopAnimating()
                    self?.noResultsLabel.text = NSLocalizedString("No data loaded", comment: "Empty list message in currencies list")
            })
            .disposed(by: disposeBag)
    }
}

