//
//  BookDataModel.swift
//  MyProduct
//
//  Created by 王雪慧 on 2020/2/29.
//  Copyright © 2020 王雪慧. All rights reserved.
//

import UIKit

class BookDataModel: NSObject {

    @objc var title:String = ""
    @objc var subtitle:String = ""
    
    init(dic:[String:Any]) {
        super.init()
        self.setValuesForKeys(dic)
    }
    
    // 字典转BookDataModel，BookDataModel中没有的key重写不抛出异常
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
    
}
