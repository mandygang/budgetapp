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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layer.masksToBounds = true;
        layer.borderWidth = 1
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
    
    func configure(for category: String){
        categoryLabel.text = category
        
//        if selected {
//            backgroundColor = UIColor(hue: 0.6889, saturation: 0.34, brightness: 1, alpha: 1.0)
//        } else {
//            backgroundColor = UIColor(hue: 0.6889, saturation: 0.14, brightness: 1, alpha: 1.0)
//        }
    }
}
