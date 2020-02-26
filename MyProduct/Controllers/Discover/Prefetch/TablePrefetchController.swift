//
//  TablePrefetchController.swift
//  MyProduct
//
//  Created by 王雪慧 on 2020/2/5.
//  Copyright © 2020 王雪慧. All rights reserved.
//

import UIKit

class TablePrefetchController: BaseViewController {

    private let dataSource = CustomTableDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor(red: 170/255.0, green: 170/255.0, blue: 170/255.0, alpha: 1)
        view.clipsToBounds = false
        
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.dataSource = dataSource
        tableView.prefetchDataSource = dataSource
        tableView.backgroundColor = .white
        tableView.register(TableViewPrefetchCell.self, forCellReuseIdentifier: TableViewPrefetchCell.reuseIdentifier)
        tableView.layer.borderColor = UIColor.black.cgColor
        tableView.layer.borderWidth = 2
        tableView.clipsToBounds = false
        tableView.rowHeight = 50
        tableView.estimatedRowHeight = 50
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(15)
            make.trailing.equalToSuperview().offset(-15)
            make.centerY.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.5)
        }
    }

}
