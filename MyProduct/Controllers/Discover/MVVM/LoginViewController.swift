//
//  LoginViewController.swift
//  MyProduct
//
//  Created by 王雪慧 on 2020/2/29.
//  Copyright © 2020 王雪慧. All rights reserved.
//

import UIKit
import ReactiveCocoa
import ReactiveSwift
import Toast_Swift

class LoginViewController: BaseViewController {

    lazy var loginViewModel = {
        return LoginViewModel()
    }()
    
    @IBOutlet weak var accountTextField: UITextField!
    @IBOutlet weak var pwdTextField: UITextField!
    @IBOutlet weak var loginBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "登录"
        
        bindModel()
    }

    func bindModel() {
        
        // 帐号控件内容同步到DataModel的帐号属性
        let accountProperty = DynamicProperty<String>(object: loginViewModel.loginDataModel,
                                               keyPath: #keyPath(LoginDataModel.account))
        accountProperty <~ accountTextField.reactive.continuousTextValues

        // 密码控件内容同步到DataModel的密码属性
        let pwdProperty = DynamicProperty<String>(object: loginViewModel.loginDataModel,
                                                      keyPath: #keyPath(LoginDataModel.pwd))
        pwdProperty <~ pwdTextField.reactive.continuousTextValues

        // 信号生成器的值同步到登录按钮的启用状态上
//        loginBtn.reactive.isEnabled <~ loginViewModel.enableLoginProducer
        // enable按钮背影为蓝色，unable按钮背影为灰色
        loginViewModel.enableLoginProducer.startWithResult { [unowned self] (result) in
            switch result {
            case let .success(value):
                self.loginBtn.isEnabled = value
                if value {
                    self.loginBtn.backgroundColor = .systemBlue
                } else {
                    self.loginBtn.backgroundColor = .lightGray
                }
            default:
                break
            }
        }
    }
    
    @IBAction func login(_ sender: Any) {
        
        loginViewModel.loginAction.apply(()).start { [unowned self] (event) in
            switch event {
            case let .value(value):
                if value == "登录成功" {
                    self.view.makeToast("登录成功", duration: 2.0, position: .center)
                }
            default:
                break
            }
        }
        
    }

}
