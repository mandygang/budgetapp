//
//  BudgetDetailViewController.swift
//  BudgetingApp
//
//  Created by Janice Jung on 11/20/19.
//  Copyright © 2019 Janice Jung. All rights reserved.
//

import UIKit

class BudgetDetailViewController: UIViewController {

    var categoryLabel: UILabel!
    var amountLabel: UILabel!
    var categoryString: String
    var amountString: String
    
    init(for budget: Budget) {
        categoryString = budget.category
        amountString = budget.amount
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        categoryLabel = UILabel()
        categoryLabel.text = categoryString
        categoryLabel.textAlignment = .center
        categoryLabel.font = UIFont.systemFont(ofSize: 30)
        view.addSubview(categoryLabel)
        
        amountLabel = UILabel()
        amountLabel.text = amountString
        amountLabel.font = UIFont.systemFont(ofSize: 20)
        view.addSubview(amountLabel)
        
        setupConstraints()
        
    }
    
    func setupConstraints() {
        categoryLabel.snp.makeConstraints { make in
            make.top.left.equalTo(view.safeAreaLayoutGuide).offset(13)
            make.right.equalTo(view.safeAreaLayoutGuide).offset(-13)
        }
        
        amountLabel.snp.makeConstraints { make in
            make.top.equalTo(categoryLabel.snp.bottom).offset(20)
            make.left.equalTo(categoryLabel)
        }
    }
    

}
