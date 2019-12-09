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
        
        tabBar.barTintColor = .lightGray
        
        setupTabBar()
    }

    func setupTabBar() {
        
        let myBudgetVC = MyBudgetsViewController()
        let expensesLogVC = ExpensesLogViewController()
        let profileVC = ProfileViewController()
        let addExpenseVC = AddExpenseViewController()
        let homeVC = HomeViewController()
        let signUpVC = SignUpViewController()
        
        viewControllers = [signUpVC, homeVC, myBudgetVC, expensesLogVC, addExpenseVC, profileVC]
//        viewControllers = controllers.map { UINavigationController(rootViewController: $0)}
        
        
    }
    
}

