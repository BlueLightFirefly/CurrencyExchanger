//
//  LoadingButton.swift
//  CurrencyExchanger
//
//  Created by Kate Dundukova on 31.03.2020.
//  Copyright © 2020 Katerina Kostritsyna. All rights reserved.
//

import Foundation
import UIKit

class LoadingButton: UIButton {
    
    private var activityIndicator: UIActivityIndicatorView?
    private var title: String?
    var isLoading: Bool = false {
        didSet {
            if activityIndicator == nil {
                activityIndicator = UIActivityIndicatorView(style: .white)
                activityIndicator!.center = CGPoint(x: frame.width / 2 + contentEdgeInsets.left / 2, y: frame.height / 2)
                addSubview(activityIndicator!)
                title = self.titleLabel?.text
            }
            
            isLoading ? activityIndicator?.startAnimating() : activityIndicator?.stopAnimating()
                self.setTitleColor(isLoading ?  backgroundColor : .white, for: .normal)
            self.isUserInteractionEnabled = !isLoading
        }
    }
}
