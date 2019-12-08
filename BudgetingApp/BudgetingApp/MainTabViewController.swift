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
        
        let myBudgetVC = UINavigationController(rootViewController: MyBudgetsViewController())
        let expensesLogVC = UINavigationController(rootViewController: ExpensesLogViewController())
        let profileVC = UINavigationController(rootViewController: ProfileViewController())
        let addExpenseVC = UINavigationController(rootViewController: AddExpenseViewController())
        let homeVC = UINavigationController(rootViewController: HomeViewController())
        let signUpVC = UINavigationController(rootViewController: SignUpViewController())
        
        viewControllers = [signUpVC, homeVC, myBudgetVC, expensesLogVC, addExpenseVC, profileVC]
//        viewControllers = controllers.map { UINavigationController(rootViewController: $0)}
        
        
    }
    
}

