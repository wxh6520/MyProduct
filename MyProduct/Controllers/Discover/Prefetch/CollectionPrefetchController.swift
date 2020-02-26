//
//  CollectionPrefetchController.swift
//  MyProduct
//
//  Created by 王雪慧 on 2020/2/5.
//  Copyright © 2020 王雪慧. All rights reserved.
//

import UIKit

class CollectionPrefetchController: BaseViewController {

    private let dataSource = CustomDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor(red: 170/255.0, green: 170/255.0, blue: 170/255.0, alpha: 1)
        view.clipsToBounds = false
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = 10
        flowLayout.minimumInteritemSpacing = 10
        flowLayout.itemSize = CGSize(width: 150, height: 100)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.dataSource = dataSource
        collectionView.prefetchDataSource = dataSource
        collectionView.backgroundColor = .white
        collectionView.register(CollectionViewPrefetchCell.self, forCellWithReuseIdentifier: CollectionViewPrefetchCell.reuseIdentifier)
        collectionView.layer.borderColor = UIColor.black.cgColor
        collectionView.layer.borderWidth = 2
        collectionView.clipsToBounds = false
        view.addSubview(collectionView)
        
        collectionView.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(15)
            make.trailing.equalToSuperview().offset(-15)
            make.centerY.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.5)
        }
    }

}
