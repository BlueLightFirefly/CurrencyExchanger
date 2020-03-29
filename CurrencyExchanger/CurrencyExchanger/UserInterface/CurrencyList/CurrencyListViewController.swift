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

class CurrencyListViewController: UIViewController {
    @IBOutlet var tableView: UITableView!
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
        networkManager.requestAllCurrencies()
            .subscribe(onNext: { curencies in
                print(curencies.count)
            }, onError: { e in
                print(e)
            }).disposed(by: disposeBag)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }
}

extension CurrencyListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows(in: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CurrencyCell", for: indexPath)
        if let currencyCell = cell as? CurrencyCell {
            currencyCell.currency = viewModel.currency(for: indexPath)
        }
        return cell
    }
    
    
}
