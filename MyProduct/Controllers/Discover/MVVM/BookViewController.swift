//
//  BookViewController.swift
//  MyProduct
//
//  Created by 王雪慧 on 2020/2/29.
//  Copyright © 2020 王雪慧. All rights reserved.
//

import UIKit

class BookViewController: BaseViewController {

    lazy var bookViewModel = {
        return BookViewModel()
    }()
    
    var table:UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "图书"
        
        view.backgroundColor = .white
        
        table = UITableView(frame: view.bounds, style: .plain)
        table.dataSource = bookViewModel
        view.addSubview(table)
        
        bookViewModel.bookAction.apply(()).startWithResult { (result) in
            switch result {
            case let .success(value):
                self.bookViewModel.models = value
                self.table.reloadData()
            default:
                break
            }
        }
        
    }

}
