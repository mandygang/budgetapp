//
//  AppDelegate.swift
//  BudgetingApp
//
//  Created by Janice Jung on 11/19/19.
//  Copyright © 2019 Janice Jung. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        
        let mainViewController = SignUpViewController()
        //window?.rootViewController = mainViewController
        
        window?.rootViewController = UINavigationController(rootViewController: SignUpViewController())
        
//        let mainViewController = MainTabViewController()
//        window?.rootViewController = mainViewController
        
        return true
    
    }

    
}

