//
//  BudgetsHeaderView.swift
//  BudgetingApp
//
//  Created by Janice Jung on 12/6/19.
//  Copyright © 2019 Janice Jung. All rights reserved.
//

protocol ReloadBudgetsDelegate: class {
    func reloadBudgets()
}

import UIKit

class BudgetsHeaderView: UICollectionReusableView {
    var addButton: UIButton!
    var monthTotalLabel: UILabel!
    
    weak var delegate: pushModallyDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .background
        
        addButton = UIButton()
        addButton.layer.borderColor = UIColor.accentGreen.cgColor
        addButton.layer.borderWidth = 2
        addButton.layer.cornerRadius = 25
        addButton.setTitle("Add a new budget", for: .normal)
        addButton.setTitleColor(.accentGreen, for: .normal)
        addButton.titleLabel?.font = .systemFont(ofSize: 20, weight: .medium)
        addButton.addTarget(self, action: #selector(pushSetBudgetViewController), for: .touchUpInside)
        addSubview(addButton)
        
        monthTotalLabel = UILabel()
        monthTotalLabel.layer.borderColor = UIColor.accentGreen.cgColor
        monthTotalLabel.layer.borderWidth = 2
        monthTotalLabel.layer.cornerRadius = 25
        //add month total
        monthTotalLabel.text = "Month total:"
        monthTotalLabel.textAlignment = .center
        monthTotalLabel.textColor = .accentGreen
        monthTotalLabel.font = .systemFont(ofSize: 20, weight: .medium)
        addSubview(monthTotalLabel)
        
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupConstraints() {
        addButton.snp.makeConstraints { make in
            make.centerX.equalTo(self)
            make.height.equalTo(55)
            make.left.equalTo(self).offset(20)
            make.top.equalTo(self).offset(25)
        }
        
        monthTotalLabel.snp.makeConstraints { make in
            make.centerX.equalTo(self)
            make.height.equalTo(55)
            make.left.equalTo(self).offset(20)
            make.top.equalTo(addButton.snp.bottom).offset(10)
        }
    }
    
    @objc func pushSetBudgetViewController() {
        let viewController = SetBudgetViewController()
        viewController.delegate = delegate
        delegate?.pushSetBudgetViewController(for: viewController)
    }
}

extension BudgetsHeaderView: ReloadBudgetsDelegate {
    func reloadBudgets() {
    //    delegate?.editBudget(budget: <#T##Budget#>, index: <#T##Int#>)
    }
}

