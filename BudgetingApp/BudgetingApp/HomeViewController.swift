//
//  HomeViewController.swift
//  BudgetingApp
//
//  Created by Janice Jung on 12/6/19.
//  Copyright © 2019 Janice Jung. All rights reserved.
//

import UIKit
import MBCircularProgressBar

class HomeViewController: UIViewController {

    var greetingLabel: UILabel!
    var checkOutLabel: UILabel!
    var bertieImageView: UIImageView!
    var bertieMessageTextView: UITextView!
    var textViewHeight: NSLayoutConstraint!
    var totalExpenses: Float?
    var totalBudget: Int?
    var percentage: Float!
    
    let textViewPadding = CGFloat(13)
    let imageViewHeight = CGFloat(70)
    
    var allExpenses: [Expense] = []
    var allBudgets: [Budget] = []
    
    let progressBar = MBCircularProgressBarView(frame: .zero)
    

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .background
        
        greetingLabel = UILabel()
        greetingLabel.text = "Hey!"
        greetingLabel.font = .systemFont(ofSize: 32, weight: .semibold)
        greetingLabel.textColor = .main
        view.addSubview(greetingLabel)
        
        
        checkOutLabel = UILabel()
        checkOutLabel.text = "check out where you're @ this month"
        checkOutLabel.font = .systemFont(ofSize: 27, weight: .medium)
        checkOutLabel.textAlignment = .center
        checkOutLabel.lineBreakMode = .byWordWrapping
        checkOutLabel.numberOfLines = 0
        checkOutLabel.textColor = .secondary
        view.addSubview(checkOutLabel)
    
        
        getTotalExpenses()
        //getTotalBudget()
        //findPercentage()

        
        progressBar.showValueString = true
        progressBar.showUnitString = true
        progressBar.unitString = "%"
        progressBar.valueFontName = NSString(string: "Arial") as String
        progressBar.valueFontSize = CGFloat(40)
        progressBar.unitFontName = NSString(string: "Arial") as String
        progressBar.unitFontSize = CGFloat(40)
        progressBar.fontColor = .accentGreen
        progressBar.decimalPlaces = 0
//        progressBar.progressRotationAngle = CGFloat(percentage)
        //progressBar.progressAngle = 0
        progressBar.progressLineWidth = 7
        progressBar.backgroundColor = .background
        progressBar.progressColor = .accentGreen
        progressBar.progressStrokeColor = .background
        progressBar.progressCapType = NSInteger(1)
        progressBar.emptyLineWidth = 0
        progressBar.emptyLineColor = .background
        progressBar.emptyCapType = NSInteger(1)
        self.view.addSubview(progressBar)
        
        
        
        bertieMessageTextView = UITextView()
        bertieMessageTextView.text = "bertie: if i were a police officer i would be pulling u over right now bc ur a speedy spender 😂 seriously though..."
        bertieMessageTextView.textAlignment = .left
        bertieMessageTextView.font = .systemFont(ofSize: 15, weight: .regular)
        bertieMessageTextView.textColor = .main
        bertieMessageTextView.backgroundColor = .bertieGreen
        bertieMessageTextView.layer.cornerRadius = 6
        bertieMessageTextView.textContainerInset = UIEdgeInsets(top: textViewPadding, left: textViewPadding+25, bottom: textViewPadding, right: textViewPadding)
        
        textViewHeight = NSLayoutConstraint()
        textViewHeight.constant = self.bertieMessageTextView.contentSize.height
        bertieMessageTextView.isScrollEnabled = false
        view.addSubview(bertieMessageTextView)
        
        bertieImageView = UIImageView()
        bertieImageView.image = UIImage(named: "bertiezoom")
        bertieImageView.layer.cornerRadius = imageViewHeight / 2
        bertieImageView.layer.masksToBounds = true
        bertieImageView.layer.borderColor = UIColor.background.cgColor
        bertieImageView.layer.borderWidth = 4
        view.addSubview(bertieImageView)
        
        
        setupConstraints()
        
    }
    
    func setupConstraints() {
        greetingLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(60)
            make.centerX.equalTo(view)
        }
        
        checkOutLabel.snp.makeConstraints { make in
            make.top.equalTo(greetingLabel.snp.bottom).offset(20)
            make.width.equalTo(400)
            make.centerX.equalTo(view)
        }
        
        progressBar.snp.makeConstraints { make in
            make.top.equalTo(checkOutLabel.snp.bottom).offset(40)
            make.centerX.equalTo(view)
            make.width.equalTo(200)
            make.height.equalTo(200)
        }
        
        bertieMessageTextView.snp.makeConstraints { make in
            make.top.equalTo(progressBar.snp.bottom).offset(40)
            make.centerX.equalTo(view).offset(15)
            make.width.equalTo(300)
        }
        
        bertieImageView.snp.makeConstraints { make in
            make.centerX.equalTo(bertieMessageTextView.snp.left)
            make.centerY.equalTo(bertieMessageTextView)
            make.width.height.equalTo(imageViewHeight)
            
        }
    }
    
    func getTotalExpenses() {
        NetworkManager.getExpensesForUser(userID: 1) { expenses in
            self.allExpenses = expenses
            self.totalExpenses = Statics.getTotalExpenses(expenses: self.allExpenses)
            print(self.totalExpenses)
            print(expenses)
            print("done getting expenses")
            self.getTotalBudget()
            
        }
    }
    
    func getTotalBudget() {
        
        NetworkManager.getBudgets(userID: 1) { budgets in
            self.allBudgets = budgets
            self.totalBudget = Statics.getTotalBudget(budgets: self.allBudgets)
            print(self.allBudgets)
            print(self.totalBudget)
            print("done getting all budgets")
            
            DispatchQueue.main.async {
                self.findPercentage()
                self.progressBar.value = CGFloat(self.percentage)
                self.progressBar.maxValue = CGFloat(100)
                self.progressBar.progressRotationAngle = CGFloat(100)
                self.progressBar.progressAngle = CGFloat(100)
            }
            
//            DispatchQueue.main.async {
//                self.budgetCollectionView.reloadData()
//            }
        }
        
    }
    
    func findPercentage() {
        if let expensesUnwrapped = totalExpenses, let budgetUnwrapped = totalBudget {
            let budgetFloat = Float(budgetUnwrapped)
            if budgetUnwrapped == 0 {
                percentage = 0

            } else {
                let divide = expensesUnwrapped / budgetFloat
                if divide > 100 {
                    percentage = 100
                } else {
                    percentage = divide * 100
                }
            }
        } else {
            percentage = 0
        }
        
        
    }
    
}
