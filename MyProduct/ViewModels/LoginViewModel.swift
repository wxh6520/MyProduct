//
//  LoginViewModel.swift
//  MyProduct
//
//  Created by 王雪慧 on 2020/2/29.
//  Copyright © 2020 王雪慧. All rights reserved.
//

import Foundation
import UIKit
import ReactiveCocoa
import ReactiveSwift

class LoginViewModel: NSObject {

    lazy var loginDataModel = {
        return LoginDataModel()
    }()
    
    var enableLoginProducer:SignalProducer<Bool,Never>!

    var loginAction:Action<(),String,Swift.Error>!

    override init() {
        super.init()
        initialBind()
    }

    func initialBind() {

        // 监听DataModel帐号属性值变化。监听属性，产生信号
        let accountProducer = loginDataModel.reactive.producer(forKeyPath: #keyPath(LoginDataModel.account))
        // 监听DataModel密码属性值变化。监听属性，产生信号
        let pwdProducer = loginDataModel.reactive.producer(forKeyPath: #keyPath(LoginDataModel.pwd))
        // 当DataModel帐号和密码属性都不为空时，信号生成器发送true，否则发送false。组装信号
        enableLoginProducer = SignalProducer.combineLatest(accountProducer, pwdProducer).map { (account,pwd) -> Bool in
            let accountStr = account as! String?
            let pwdStr = pwd as! String?
            let enabled = (accountStr != nil && accountStr?.count != 0) && (pwdStr != nil && pwdStr?.count != 0)
            return enabled
        }

        // 登录业务。产生信号
        loginAction = Action<(),String,Swift.Error> { (_) -> SignalProducer<String, Swift.Error> in

            SignalProducer({ (observer, _) in
                observer.send(value: "登录成功")
                observer.sendCompleted()
            })
        }

    }
    
}
