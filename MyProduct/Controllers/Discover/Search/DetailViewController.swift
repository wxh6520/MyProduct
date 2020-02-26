//
//  DetailViewController.swift
//  MyProduct
//
//  Created by 王雪慧 on 2020/2/9.
//  Copyright © 2020 王雪慧. All rights reserved.
//

import UIKit
import SnapKit

class DetailViewController: BaseViewController {
    
    // MARK: - Properties

    var product: Product!
    
    private var yearLabel: UILabel!
    private var priceLabel: UILabel!
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        let year = UILabel(frame: .zero)
        year.backgroundColor = .clear
        year.text = "Year:"
        year.textAlignment = .left
        view.addSubview(year)
        year.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(16)
            make.top.equalToSuperview().offset(10 + StatusBarAndNavigationBarHeight())
            make.width.equalTo(38.5)
        }
        
        let price = UILabel(frame: .zero)
        price.backgroundColor = .clear
        price.text = "Price:"
        price.textAlignment = .left
        view.addSubview(price)
        price.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(16)
            make.top.equalTo(year.snp.bottom).offset(8)
            make.width.equalTo(44)
        }
        
        yearLabel = UILabel(frame: .zero)
        yearLabel.backgroundColor = .clear
        yearLabel.textAlignment = .left
        view.addSubview(yearLabel)
        yearLabel.snp.makeConstraints { (make) in
            make.left.equalTo(year.snp.right).offset(13.5)
            make.top.equalToSuperview().offset(10 + StatusBarAndNavigationBarHeight())
            make.right.equalToSuperview()
        }
        
        priceLabel = UILabel(frame: .zero)
        priceLabel.backgroundColor = .clear
        priceLabel.textAlignment = .left
        view.addSubview(priceLabel)
        priceLabel.snp.makeConstraints { (make) in
            make.left.equalTo(price.snp.right).offset(8)
            make.top.equalTo(yearLabel.snp.bottom).offset(8)
            make.right.equalToSuperview()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if #available(iOS 11.0, *) {
            self.navigationItem.largeTitleDisplayMode = .never
        }
        
        title = product.title
        
        yearLabel.text = "\(product.yearIntroduced)"
        
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .currency
        numberFormatter.formatterBehavior = .default
        let priceString = numberFormatter.string(from: NSNumber(value: product.introPrice))
        priceLabel.text = priceString
    }
    
}
