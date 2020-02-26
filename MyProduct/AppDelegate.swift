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
        if let shortcutItem = shortcutItemToProcess {
            // In this sample an alert is being shown to indicate that the action has been triggered,
            // but in real code the functionality for the quick action would be triggered.
            var message = "\(shortcutItem.type) triggered"
            if let name = shortcutItem.userInfo?["Name"] {
                message += " for \(name)"
            }
            let alertController = UIAlertController(title: "Quick Action", message: message, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Close", style: .default, handler: nil))
            application.keyWindow?.rootViewController?.present(alertController, animated: true, completion: nil)

            // Reset the shortcut item so it's never processed twice.
            shortcutItemToProcess = nil
        }
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        let signature = UIApplicationShortcutItem(type: "SignatureAction", localizedTitle: "签名", localizedSubtitle: "Sign your name", icon: UIApplicationShortcutIcon(type: .compose), userInfo: nil)
        application.shortcutItems = [signature]
    }
    
}

@available (iOS 13, *)
extension AppDelegate {
    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
}
