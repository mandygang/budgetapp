//
//  MyBudgetsCollectionViewCell.swift
//  BudgetingApp
//
//  Created by Janice Jung on 11/20/19.
//  Copyright © 2019 Janice Jung. All rights reserved.
//

import UIKit

class MyBudgetsCollectionViewCell: UICollectionViewCell {
    
    var amountLabel: UILabel!
    var categoryLabel: UILabel!
    var currentlyLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        layer.masksToBounds = true
        layer.cornerRadius = 30
        
        categoryLabel = UILabel()
        categoryLabel.font = .systemFont(ofSize: 27, weight: .medium)
        categoryLabel.sizeToFit()
        categoryLabel.textColor = .black
        contentView.addSubview(categoryLabel)
        
        amountLabel = UILabel()
        amountLabel.font = .systemFont(ofSize: 27, weight: .medium)
        amountLabel.sizeToFit()
        amountLabel.textColor = .black
        amountLabel.backgroundColor = .clear
        contentView.addSubview(amountLabel)

        
        currentlyLabel = UILabel()
        currentlyLabel.text = "currently:"
        currentlyLabel.textColor = .secondary
        currentlyLabel.font = .systemFont(ofSize: 18, weight: .medium)
        contentView.addSubview(currentlyLabel)
        
        setupConstraints()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupConstraints() {
        categoryLabel.snp.makeConstraints { make in
            make.top.left.equalTo(contentView).offset(30)
        }
        
        amountLabel.snp.makeConstraints { make in
            make.left.equalTo(categoryLabel.snp.right).offset(10)
            make.top.equalTo(categoryLabel)
        }
        
        currentlyLabel.snp.makeConstraints { make in
            make.top.equalTo(categoryLabel.snp.bottom).offset(7)
            make.left.equalTo(categoryLabel)
        }
    }
    
    func configure(for budget: Budget) {
        categoryLabel.text = budget.category + ":"
        amountLabel.text = "$" + budget.amount
    }
    
}


