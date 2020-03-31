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
    
    let viewModel: CurrencyListViewModel = CurrencyListViewModel()
    private var networkManager = NetworkManager()
    private var disposeBag = DisposeBag()
    private var searchController: UISearchController?
    
    class func fromStoryboard() -> CurrencyListViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "CurrencyListViewController") as! CurrencyListViewController
        return controller
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchBar()
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
        tableView.rx.modelSelected(Currency.self)
            .subscribe(onNext:{ [weak self] currency in
                guard let strongSelf = self else { return }
                strongSelf.viewModel.selected(currency: currency)
                if strongSelf.searchController?.isActive ?? false {
                    strongSelf.searchController?.isActive = false
                    strongSelf.perform(#selector(strongSelf.dismissVC), with: self, afterDelay: TimeInterval(0.5))
                } else {
                    strongSelf.dismissVC()
                }
            })
            .disposed(by: disposeBag)
        
    }
    
    @objc func dismissVC() {
        self.navigationController?.popViewController(animated: true)
    }
    
    private func setupSearchBar() {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.searchBarStyle = .minimal
        searchController.dimsBackgroundDuringPresentation = false
        if #available(iOS 11.0, *) {
            self.navigationItem.searchController = searchController
        } else {
            self.tableView.tableHeaderView = searchController.searchBar
        }
        searchController.searchBar.rx.text.orEmpty
            .throttle(.milliseconds(300), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] value in
                self?.viewModel.filter = value
            })
            .disposed(by: disposeBag)
        self.searchController = searchController
    }
}

