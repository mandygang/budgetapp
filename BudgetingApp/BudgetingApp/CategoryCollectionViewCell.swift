//
//  CategoryCollectionViewCell.swift
//  BudgetingApp
//
//  Created by Janice Jung on 11/21/19.
//  Copyright © 2019 Janice Jung. All rights reserved.
//

import UIKit

class CategoryCollectionViewCell: UICollectionViewCell {
    var categoryLabel: UILabel!
    let padding = CGFloat(3)
    var selectedCat: String?
    var isItSelected: Bool?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layer.masksToBounds = true;
        layer.borderWidth = 1
        if let isSelected = isItSelected {
            if isSelected {
                layer.borderColor = UIColor.accentGreen.cgColor
                backgroundColor = .accentGreen
            } else {
                layer.borderColor = UIColor.accentGreen.cgColor
                backgroundColor = .background
            }
        } else {
            layer.borderColor = UIColor.accentGreen.cgColor
            backgroundColor = .background
        }
        layer.borderColor = UIColor.accentGreen.cgColor
        layer.cornerRadius = 6;
        backgroundColor = .background
        
        categoryLabel = UILabel()
        categoryLabel.textColor = .accentGreen
        contentView.addSubview(categoryLabel)
        
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupConstraints() {
        categoryLabel.snp.makeConstraints { make in
            make.centerX.centerY.equalTo(contentView)
        }
    }
    
    func configure(for category: String, selected: String?){
        categoryLabel.text = category
        
        if let selectedCat = selected {
            if category == selectedCat {
                isItSelected = true
            } else {
                isItSelected = false
            }
        }

    }
}
