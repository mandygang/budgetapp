//
//  ExpenseCollectionViewCell.swift
//  BudgetingApp
//
//  Created by Janice Jung on 11/21/19.
//  Copyright © 2019 Janice Jung. All rights reserved.
//

import UIKit

class ExpenseCollectionViewCell: UICollectionViewCell {
    var titleLabel: UILabel!
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
        amountLabel.font = .systemFont(ofSize: 22, weight: .bold)
        amountLabel.sizeToFit()
        amountLabel.textColor = .accentGreen
        amountLabel.backgroundColor = .clear
        contentView.addSubview(amountLabel)
        
        titleLabel = UILabel()
        titleLabel.font = UIFont.boldSystemFont(ofSize: 22)
        titleLabel.sizeToFit()
        titleLabel.textColor = .black
        contentView.addSubview(titleLabel)
        
        noteLabel = UILabel()
        noteLabel.font = .systemFont(ofSize: 15, weight: .medium)
        noteLabel.sizeToFit()
        noteLabel.textColor = .meta
        contentView.addSubview(noteLabel)
        
        categoryLabel = UILabel()
        categoryLabel.font = .systemFont(ofSize: 15, weight: .medium)
        categoryLabel.sizeToFit()
        categoryLabel.textColor = .secondary
        contentView.addSubview(categoryLabel)
        
        setupConstraints()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(contentView).offset(25)
            make.leading.equalTo(contentView).offset(35)
        }
        
        amountLabel.snp.makeConstraints { make in
            make.trailing.equalTo(self).offset(-40)
            make.centerY.equalTo(contentView)
        }
        
        categoryLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.left.equalTo(titleLabel)
        }
        
        noteLabel.snp.makeConstraints { make in
            make.top.equalTo(categoryLabel.snp.bottom)
            make.left.equalTo(titleLabel)
        }
    }
    
    func configure(for expense: Expense) {
        categoryLabel.text = Statics.categories[expense.tag]
        amountLabel.text = "$" + String(expense.amount)
        noteLabel.text = expense.description
        titleLabel.text = expense.title
        
    }
    
    
}
