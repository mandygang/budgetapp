//
//  ExpenseCollectionViewCell.swift
//  BudgetingApp
//
//  Created by Janice Jung on 11/21/19.
//  Copyright © 2019 Janice Jung. All rights reserved.
//

import UIKit

class ExpenseCollectionViewCell: UICollectionViewCell {
    var categoryLabel: UILabel!
    var amountLabel: UILabel!
    var noteLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        layer.masksToBounds = true
        //edit corner radius
        layer.cornerRadius = 50
        
        amountLabel = UILabel()
        amountLabel.font = UIFont.systemFont(ofSize: 15)
        amountLabel.sizeToFit()
        amountLabel.textColor = .accentGreen
        amountLabel.backgroundColor = .clear
        contentView.addSubview(amountLabel)
        
        categoryLabel = UILabel()
        categoryLabel.font = UIFont.boldSystemFont(ofSize: 20)
        categoryLabel.sizeToFit()
        categoryLabel.textColor = .black
        contentView.addSubview(categoryLabel)
        
        noteLabel = UILabel()
        noteLabel.font = UIFont.boldSystemFont(ofSize: 10)
        noteLabel.sizeToFit()
        noteLabel.textColor = .gray
        contentView.addSubview(noteLabel)
        
        setupConstraints()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupConstraints() {
        categoryLabel.snp.makeConstraints { make in
            make.top.left.equalTo(contentView).offset(40)
        }
        
        amountLabel.snp.makeConstraints { make in
            make.left.equalTo(categoryLabel)
            make.top.equalTo(categoryLabel.snp.bottom).offset(40)
        }
        
        noteLabel.snp.makeConstraints { make in
            make.top.equalTo(amountLabel.snp.bottom)
            make.left.equalTo(categoryLabel)
        }
    }
    
    func configure(for expense: Expense) {
        categoryLabel.text = Statics.categories[expense.tag]
        amountLabel.text = String(expense.amount)
        noteLabel.text = expense.description
    }
    
    
}
