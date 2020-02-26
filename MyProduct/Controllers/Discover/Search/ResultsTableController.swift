//
//  ResultsTableController.swift
//  MyProduct
//
//  Created by 王雪慧 on 2020/2/9.
//  Copyright © 2020 王雪慧. All rights reserved.
//

import UIKit

class ResultsTableController: BaseSearchController {
    
    init() {
        super.init(style: .plain)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: - UITableViewDataSource
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredProducts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell!  = tableView.dequeueReusableCell(withIdentifier: BaseSearchController.tableViewCellIdentifier)
        if cell == nil {
            cell = UITableViewCell(style: .value1, reuseIdentifier: BaseSearchController.tableViewCellIdentifier)
        }
        let product = filteredProducts[indexPath.row]
        configureCell(cell, forProduct: product)
        
        return cell
    }
}
