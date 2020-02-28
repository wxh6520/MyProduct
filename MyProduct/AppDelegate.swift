//
//  AppDelegate.swift
//  MyProduct
//
//  Created by 王雪慧 on 2020/1/15.
//  Copyright © 2020 王雪慧. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    var shortcutItemToProcess: UIApplicationShortcutItem?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        IQKeyboardManager.shared.enable = true
        
        if let shortcutItem = launchOptions?[UIApplication.LaunchOptionsKey.shortcutItem] as? UIApplicationShortcutItem {
            shortcutItemToProcess = shortcutItem
        }
        
        return true
    }

    func application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
        shortcutItemToProcess = shortcutItem
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        UIApplication.shared.keyWindow?.backgroundColor = .white
        
        if let shortcutItem = shortcutItemToProcess {
            // In this sample an alert is being shown to indicate that the action has been triggered,
            // but in real code the functionality for the quick action would be triggered.
//            var message = "\(shortcutItem.type) triggered"
//            if let name = shortcutItem.userInfo?["Name"] {
//                message += " for \(name)"
//            }
//            let alertController = UIAlertController(title: "Quick Action", message: message, preferredStyle: .alert)
//            alertController.addAction(UIAlertAction(title: "Close", style: .default, handler: nil))
//            application.keyWindow?.rootViewController?.present(alertController, animated: true, completion: nil)
//
//            // Reset the shortcut item so it's never processed twice.
//            shortcutItemToProcess = nil
            
            if let tabCtr = UIApplication.shared.keyWindow?.rootViewController as? UITabBarController {
                tabCtr.selectedIndex = 0
                if let nav = tabCtr.viewControllers?.first as? UINavigationController {
                    switch shortcutItem.type {
                    case "SearchAction":
                        let search = TableSearchController()
                        nav.pushViewController(search, animated: true)
                    case "SignatureAction":
                        let signature = CanvasMainViewController(nibName: "CanvasMainViewController", bundle: nil)
                        nav.pushViewController(signature, animated: true)
                    default:
                        print("")
                    }
                }
            }

            // Reset the shortcut item so it's never processed twice.
            shortcutItemToProcess = nil
        }
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        let signature = UIApplicationShortcutItem(type: "SignatureAction", localizedTitle: "签名", localizedSubtitle: "Sign your name", icon: UIApplicationShortcutIcon(type: .compose), userInfo: nil)
        application.shortcutItems = [signature]
    }
    
}
