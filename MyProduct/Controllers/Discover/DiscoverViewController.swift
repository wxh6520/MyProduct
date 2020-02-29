//
//  DiscoverViewController.swift
//  MyProduct
//
//  Created by 王雪慧 on 2020/1/15.
//  Copyright © 2020 王雪慧. All rights reserved.
//

import UIKit

class DiscoverViewController: UITableViewController {

    static let cellIdentifier = "DiscoverViewController"
    
    var dataArray = [DiscoverKeys]() {
        didSet {
            tableView.reloadData()
        }
    }

    enum DiscoverKeys: String {
        case item = "增删改查"
        case multiSelect = "选择多项"
        case prefetch = "预加载"
        case waterfall = "瀑布流"
        case search = "搜索"
        case signature = "签名"
        case animation = "动画"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "发现"
        
        // Do any additional setup after loading the view.
        tableView.estimatedRowHeight = 50
        tableView.separatorStyle = .singleLine
        
        dataArray.append(contentsOf: [.item, .multiSelect, .prefetch, .waterfall, .search, .signature, .animation])
    }
    
    // MARK: - UITableViewDataSource

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell! = tableView.dequeueReusableCell(withIdentifier: DiscoverViewController.cellIdentifier)
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: DiscoverViewController.cellIdentifier)
        }
        
        cell.textLabel?.text = dataArray[indexPath.row].rawValue
        cell.accessoryType = .disclosureIndicator
        
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch dataArray[indexPath.row] {
        case .item:
            let itemCtr = ItemMasterViewController()
            navigationController?.pushViewController(itemCtr, animated: true)
        case .multiSelect:
            let selectCtr = MultiSelectViewController()
            navigationController?.pushViewController(selectCtr, animated: true)
        case .prefetch:
            let prefetch = PrefetchViewController()
            navigationController?.pushViewController(prefetch, animated: true)
        case .waterfall:
            let waterfall = WaterfallCollectionController()
            navigationController?.pushViewController(waterfall, animated: true)
        case .search:
            let search = TableSearchController()
            navigationController?.pushViewController(search, animated: true)
        case .signature:
            let signature = CanvasMainViewController(nibName: "CanvasMainViewController", bundle: nil)
            navigationController?.pushViewController(signature, animated: true)
        case .animation:
            let animation = LottieViewController()
            navigationController?.pushViewController(animation, animated: true)
        }
    }
    
}
