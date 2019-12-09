//
//  ViewController.swift
//  BudgetingApp
//
//  Created by Janice Jung on 11/19/19.
//  Copyright © 2019 Janice Jung. All rights reserved.
//

import UIKit

class MainTabViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBar.barTintColor = .white
        tabBar.tintColor = UIColor(red:0.02, green:0.04, blue:0.09, alpha:1.0)
        
        setupTabBar()
    }

    func setupTabBar() {
        
        let myBudgetVC = MyBudgetsViewController()
        myBudgetVC.tabBarItem.image = UIImage(named: "budget")
        myBudgetVC.tabBarItem.title = ""
        let expensesLogVC = ExpensesLogViewController()
        expensesLogVC.tabBarItem.image = UIImage(named: "expense")
         expensesLogVC.tabBarItem.title = ""
       // let profileVC = ProfileViewController()
       // let addExpenseVC = AddExpenseViewController()
        let homeVC = HomeViewController()
        homeVC.tabBarItem.image = UIImage(named: "home")
         homeVC.tabBarItem.title = ""
//        homeVC.tabBarItem.
       // let signUpVC = SignUpViewController()
        
        viewControllers = [homeVC, myBudgetVC, expensesLogVC]
//        viewControllers = controllers.map { UINavigationController(rootViewController: $0)}
        
        
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        let newTabBarHeight = defaultTabBarHeight + 16.0

        var newFrame = tabBar.frame
        newFrame.size.height = newTabBarHeight
        newFrame.origin.y = view.frame.size.height - newTabBarHeight

        tabBar.frame = newFrame
    }
    
//    override func viewWillLayoutSubviews() {
//        var tabFrame = self.tabBar.frame
//        // - 40 is editable , the default value is 49 px, below lowers the tabbar and above increases the tab bar size
//        tabFrame.size.height = 500
//        tabFrame.origin.y = self.view.frame.size.height - 500
//        self.tabBar.frame = tabFrame
//    }
    
//    override func viewWillLayoutSubviews() {
//
//
//        super.viewWillLayoutSubviews()
//
//        tabBar.frame.size.height = 500
//        tabBar.frame.origin.y = view.frame.height - 500
//    }
    
}

