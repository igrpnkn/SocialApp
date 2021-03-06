//
//  UITableViewControllerExtension.swift
//  SocialApp
//
//  Created by developer on 12.02.2021.
//

import Foundation
import UIKit

extension UITableViewController {
    
    func setupRefreshControl() {
        refreshControl = UIRefreshControl()
        refreshControl?.tintColor = .label
        refreshControl?.addTarget(self, action: #selector(refreshData), for: .valueChanged)
    }
    
    @objc func refreshData() {
    }
    
}
