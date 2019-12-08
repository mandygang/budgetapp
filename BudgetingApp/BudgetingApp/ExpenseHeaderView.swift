//
//  ExpenseHeaderView.swift
//  BudgetingApp
//
//  Created by Janice Jung on 12/5/19.
//  Copyright © 2019 Janice Jung. All rights reserved.
//

import UIKit

class ExpenseHeaderView: UICollectionReusableView {
    var categoryCollectionView: UICollectionView!
    let CategoryCellReuseIdentifier = "categoryCellReuseIdentifier"
    var categories: [String] = []
    var selectedCategory: String?
    
    var summaryLabel: UILabel!
    var budgetLabel: UILabel!
    var moneyLeftLabel: UILabel!
    var whiteBackground: UILabel!
    
    weak var delegate: FilterExpensesDelegate?
    
    let summaryFontSize = CGFloat(18)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .background
        
        categories = ["Food", "Entertainment", "Bills", "Groceries", "Shop", "Transport", "Other"]

        let categoryLayout = UICollectionViewFlowLayout()
        categoryLayout.scrollDirection = .horizontal
        categoryLayout.minimumLineSpacing = CGFloat(8)
        categoryLayout.minimumInteritemSpacing = CGFloat(8)
        
        summaryLabel = UILabel()
        summaryLabel.text = "Summary"
        summaryLabel.font = .systemFont(ofSize: summaryFontSize, weight: .medium)
        summaryLabel.textColor = .main
        addSubview(summaryLabel)
        
        categoryCollectionView = UICollectionView(frame: .zero, collectionViewLayout: categoryLayout)
        categoryCollectionView.backgroundColor = .background
        categoryCollectionView.register(CategoryCollectionViewCell.self, forCellWithReuseIdentifier: CategoryCellReuseIdentifier)
        categoryCollectionView.showsHorizontalScrollIndicator = false
        categoryCollectionView.dataSource = self
        categoryCollectionView.delegate = self
        addSubview(categoryCollectionView)
        
        
        whiteBackground = UILabel()
        whiteBackground.backgroundColor = .white
        whiteBackground.layer.cornerRadius = 13
        whiteBackground.layer.masksToBounds = true
        addSubview(whiteBackground)
        
        budgetLabel = UILabel()
        budgetLabel.text = "Overall Budget"
        budgetLabel.font = .systemFont(ofSize: summaryFontSize, weight: .medium)
        budgetLabel.textColor = .secondary
        addSubview(budgetLabel)
        
        moneyLeftLabel = UILabel()
        
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupConstraints() {
        categoryCollectionView.snp.makeConstraints { make in
            make.top.left.right.equalTo(self.safeAreaLayoutGuide).inset(UIEdgeInsets(top:20, left: 0, bottom: 20, right: 0))
            make.height.equalTo(40)
        }
        
        summaryLabel.snp.makeConstraints { make in
            make.top.equalTo(categoryCollectionView.snp.bottom).offset(20)
            make.left.equalTo(self).offset(15)
            //make.height.equalTo(100)
            make.width.equalTo(100)
            print("hello")
        }
        
        whiteBackground.snp.makeConstraints { make in
            make.top.equalTo(summaryLabel.snp.bottom).offset(13)
            make.width.equalTo(self.frame.width - 30)
            make.centerX.equalTo(self)
            make.height.equalTo(150)
        }
        
        budgetLabel.snp.makeConstraints { make in
            make.left.top.equalTo(whiteBackground).offset(12)
        }
    }
    
}


extension ExpenseHeaderView: UICollectionViewDelegate, UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let category = categories[indexPath.row]
        let cell = categoryCollectionView.dequeueReusableCell(withReuseIdentifier: CategoryCellReuseIdentifier, for: indexPath) as! CategoryCollectionViewCell
        cell.configure(for: category)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedCell = categoryCollectionView.cellForItem(at: indexPath) as! CategoryCollectionViewCell
        let category = categories[indexPath.row]
        if selectedCategory != category {
            selectedCategory = category
        } else {
            selectedCategory = nil
        }
        delegate?.filter(for: selectedCategory)
    }

}

extension ExpenseHeaderView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let label = UILabel(frame: CGRect.zero)
        label.text = categories[indexPath.row]
        label.sizeToFit()
        return CGSize(width: label.frame.width+20, height: 32)
    }
}
