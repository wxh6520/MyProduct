//
//  BaseSearchController.swift
//  MyProduct
//
//  Created by 王雪慧 on 2020/2/9.
//  Copyright © 2020 王雪慧. All rights reserved.
//

import UIKit

import UIKit

class BaseSearchController: BaseTableViewController {
    
    // MARK: - Properties
    
    var filteredProducts = [Product]()
    private var numberFormatter = NumberFormatter()
    
    // MARK: - Constants
    
    static let tableViewCellIdentifier = "cellID"
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        numberFormatter.numberStyle = .currency
        numberFormatter.formatterBehavior = .default
    }
    
    // MARK: - Configuration
    
    func configureCell(_ cell: UITableViewCell, forProduct product: Product) {
        cell.textLabel?.text = product.title
        
        /** Build the price and year string.
            Use NSNumberFormatter to get the currency format out of this NSNumber (product.introPrice).
        */
        let priceString = numberFormatter.string(from: NSNumber(value: product.introPrice))

        cell.detailTextLabel?.text = "\(priceString!) | \(product.yearIntroduced)"
    }
}
