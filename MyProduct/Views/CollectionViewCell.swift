//
//  CollectionViewCell.swift
//  MyProduct
//
//  Created by 王雪慧 on 2020/1/17.
//  Copyright © 2020 王雪慧. All rights reserved.
//

import UIKit
import SnapKit

class CollectionViewCell: UICollectionViewCell {
    
    static let reuseIdentifier = "reuseIdentifier"

    var imageView: UIImageView!
    var imageViewOverlay: UIView!
    var imageViewSelected: UIImageView!
    var imageViewUnselected: UIImageView!
    
    private var showSelectionIcons = false

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        imageView = UIImageView(frame: .zero)
        if #available(iOS 13.0, *) {
            imageView.image = UIImage(systemName: "photo")
        } else {
            imageView.image = UIImage(named: "photo")
        }
        imageView.backgroundColor = .clear
        contentView.addSubview(imageView)
        
        imageView.snp.makeConstraints { (make) in
            make.left.right.top.bottom.equalToSuperview()
        }
        
        imageViewOverlay = UIImageView(frame: .zero)
        imageViewOverlay.backgroundColor = UIColor(red: 164/255.0, green: 164/255.0, blue: 164/255.0, alpha: 0.5)
        contentView.addSubview(imageViewOverlay)
        
        imageViewOverlay.snp.makeConstraints { (make) in
            make.left.right.top.bottom.equalToSuperview()
        }
        
        imageViewUnselected = UIImageView(frame: .zero)
        if #available(iOS 13.0, *) {
            imageViewUnselected.image = UIImage(systemName: "circle")
        } else {
            imageViewUnselected.image = UIImage(named: "circle")
        }
        imageViewUnselected.layer.cornerRadius = 10
        imageViewUnselected.backgroundColor = .white
        contentView.addSubview(imageViewUnselected)
        
        imageViewUnselected.snp.makeConstraints { (make) in
            make.right.bottom.equalToSuperview().offset(-4)
            make.width.equalTo(20)
            make.height.equalTo(20)
        }
        
        imageViewSelected = UIImageView(frame: .zero)
        if #available(iOS 13.0, *) {
            imageViewSelected.image = UIImage(systemName: "checkmark.circle.fill")
        } else {
            imageViewSelected.image = UIImage(named: "checkmark.circle.fill")
        }
        imageViewSelected.layer.cornerRadius = 10
        imageViewSelected.backgroundColor = .white
        contentView.addSubview(imageViewSelected)
        
        imageViewSelected.snp.makeConstraints { (make) in
            make.edges.equalTo(imageViewUnselected)
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
//    override func awakeFromNib() {
//        super.awakeFromNib()
//        // Turn `imageViewSelected` into a circle to make its background
//        // color act as a border around the checkmark symbol.
//        imageViewSelected.layer.cornerRadius = imageViewSelected.bounds.width / 2
//        imageViewUnselected.layer.cornerRadius = imageViewSelected.bounds.width / 2
//    }
    
    func configureCell(with model: PhotoModel, showSelectionIcons: Bool) {
        self.showSelectionIcons = showSelectionIcons
        if let image = model.image {
            imageView.image = image
        }
        showSelectionOverlay()
    }
    
    private func showSelectionOverlay() {
        let alpha: CGFloat = (isSelected && showSelectionIcons) ? 1.0 : 0.0
        imageViewOverlay.alpha = alpha
        imageViewSelected.alpha = alpha
        imageViewUnselected.alpha = showSelectionIcons ? 1.0 : 0.0
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        isSelected = false
        showSelectionIcons = false
        showSelectionOverlay()
    }
    
    override var isSelected: Bool {
        didSet {
            showSelectionOverlay()
            setNeedsLayout()
        }
    }
}
