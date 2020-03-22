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
        
        // 请求图书列表，观察结果，得到数据后刷新列表。监听信号，数据更新，视图更新
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
