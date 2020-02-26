//
//  PrefetchViewController.swift
//  MyProduct
//
//  Created by 王雪慧 on 2020/2/5.
//  Copyright © 2020 王雪慧. All rights reserved.
//

import UIKit

class PrefetchViewController: BaseViewController {

    var tableCtr: TablePrefetchController!
    var collectionCtr: CollectionPrefetchController!
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        
        // Do any additional setup after loading the view.
        let segmentedControl = UISegmentedControl(items: ["TableView", "CollectionView"])
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.autoresizingMask = .flexibleWidth
        segmentedControl.frame = CGRect(x: 0, y: 0, width: 200, height: 30)
        segmentedControl.addTarget(self, action: #selector(action(_:)), for: .valueChanged)
        self.navigationItem.titleView = segmentedControl
        
        self.addChildCtr()
    }
    
    func addChildCtr() {
        collectionCtr = CollectionPrefetchController()
        addChild(collectionCtr)
        view.addSubview(collectionCtr.view)
        
        collectionCtr.view.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        collectionCtr.didMove(toParent: self)
        
        tableCtr = TablePrefetchController()
        addChild(tableCtr)
        view.addSubview(tableCtr.view)
        
        tableCtr.view.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        tableCtr.didMove(toParent: self)
    }
    
    func removeChildCtr() {
        tableCtr.willMove(toParent: nil)
        tableCtr.view.snp.removeConstraints()
        tableCtr.view.removeFromSuperview()
        tableCtr.removeFromParent()
        
        collectionCtr.willMove(toParent: nil)
        collectionCtr.view.snp.removeConstraints()
        collectionCtr.view.removeFromSuperview()
        collectionCtr.removeFromParent()
    }
    
    deinit {
        removeChildCtr()
    }
    
    // MARK: - Actions
    
    @objc
    func action(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            UIView.animate(withDuration: 0.3) {
                self.view.bringSubviewToFront(self.tableCtr.view)
            }
        case 1:
            UIView.animate(withDuration: 0.3) {
                self.view.bringSubviewToFront(self.collectionCtr.view)
            }
        default:
            return
        }
    }

}
