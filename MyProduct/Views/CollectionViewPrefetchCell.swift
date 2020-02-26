//
//  CollectionViewPrefetchCell.swift
//  MyProduct
//
//  Created by 王雪慧 on 2020/2/5.
//  Copyright © 2020 王雪慧. All rights reserved.
//

import UIKit

final class CollectionViewPrefetchCell: UICollectionViewCell {
    // MARK: Properties

    static let reuseIdentifier = "CollectionViewPrefetchCell"

    /// The `UUID` for the data this cell is presenting.
    var representedId: UUID?

    // MARK: UICollectionViewCell
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layer.borderWidth = 1.0
        layer.borderColor = UIColor.red.cgColor
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: Convenience

    /**
     Configures the cell for display based on the model.
     
     - Parameters:
         - data: An optional `DisplayData` object to display.
     
     - Tag: Cell_Config
    */
    func configure(with data: DisplayData?) {
        backgroundColor = data?.color
    }
}
