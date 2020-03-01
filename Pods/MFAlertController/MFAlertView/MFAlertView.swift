//
//  MFAlertView.swift
//  MFAlertView_Swift
//
//  Created by 王雪慧 on 2016/12/27.
//  Copyright © 2016年 王雪慧. All rights reserved.
//

import Foundation
import UIKit

@objc public class MFAlertView:NSObject,UIAlertViewDelegate {
    
    static let sharedInstance = MFAlertView()
    
    let versionNum = (UIDevice.current.systemVersion as NSString).floatValue
    
    //MARK:
    //MARK:提示框(温馨提示-确定)
    public static func yuanfang(msg:String , ctr:UIViewController) {
        MFAlertView.sharedInstance.alert(msg: msg , ctr: ctr)
    }
    
    //MARK:
    //MARK:提示框带回调(温馨提示-消息-确定)
    public static func yuanfang(msg:String , okBlock:@escaping ()->Void , ctr:UIViewController) {
        MFAlertView.sharedInstance.alert(msg: msg , okBlock: okBlock, ctr: ctr)
    }
    
    //MARK:
    //MARK:提示框带回调(温馨提示-消息-确定-取消)
    public static func yuanfangDouble(msg:String , okBlock:@escaping ()->Void , ctr:UIViewController) {
        MFAlertView.sharedInstance.alert(msg: msg , cancelTitle: "取消" , okBlock: okBlock , ctr: ctr)
    }
    
    //MARK:
    //MARK:提示框带回调(标题-密码-确定-取消)
    public static func yuanfangPwd(title:String , pwdBlock:@escaping (String?)->Void , ctr:UIViewController) {
        MFAlertView.sharedInstance.alert(title: title, msg: "" , cancelTitle: "取消", pwdBlock: pwdBlock , ctr: ctr)
    }
    
    //MARK:
    var sureAction:(()->Void)?
    var pwdAction:((String?)->Void)?
    var cancelExist:String?
    
    private func alert(title:String = "温馨提示" , msg:String , okTitle:String = "确定" , cancelTitle:String? = nil , pwdBlock:((String?)->Void)? = nil , okBlock:@escaping ()->Void = {} , ctr:UIViewController) {
        
        if versionNum >= 8 {
            
            let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
            
            if pwdBlock != nil{
                alert.addTextField(configurationHandler: { textField in
                    textField.isSecureTextEntry = true
                    textField.placeholder = "Password"
                })
            }
            
            let defaultAction = UIAlertAction(title: okTitle, style: .default, handler: { _ in
                if let pwdAction = pwdBlock{
                    pwdAction(alert.textFields?.first?.text)
                }else{
                    okBlock()
                }
            })
            alert.addAction(defaultAction)
            
            if let cancelTitleStr = cancelTitle{
                let cancelAction = UIAlertAction(title: cancelTitleStr, style: .cancel, handler: { _ in })
                alert.addAction(cancelAction)
            }
            
            ctr.present(alert, animated: true, completion: nil)
            
        }else{
        
            cancelExist = cancelTitle
            sureAction = okBlock
            
            let alert = UIAlertView(title: title, message: msg, delegate: self, cancelButtonTitle: cancelTitle, otherButtonTitles: okTitle)
            if pwdBlock != nil{
                pwdAction = pwdBlock
                alert.alertViewStyle = .secureTextInput
            }
            alert.show()
            
        }
        
    }
    
    //MARK:
    //MARK:UIAlertViewDelegate
    public func alertView(_ alertView: UIAlertView, clickedButtonAt buttonIndex: Int){
        
        if cancelExist == nil{
            if buttonIndex == 0{
                if let pwdOperation = pwdAction{
                    if let pwdTextField = alertView.textField(at: 0){
                        pwdOperation(pwdTextField.text)
                    }
                }else{
                    sureAction?()
                }
            }
        }else{
            if buttonIndex == 1{
                if let pwdOperation = pwdAction{
                    if let pwdTextField = alertView.textField(at: 0){
                        pwdOperation(pwdTextField.text)
                    }
                }else{
                    sureAction?()
                }
            }
        }
        
    }
    
}
