//
//  EditBudgetViewController.swift
//  BudgetingApp
//
//  Created by Janice Jung on 12/6/19.
//  Copyright © 2019 Janice Jung. All rights reserved.
//

import UIKit

class EditBudgetViewController: UIViewController {

    var amountPerMonthLabel: UILabel!
    var editBudgetLabel: UILabel!
    var categoryString: String
    var amountString: String
    var amountTextField: UITextField!
    var saveButton: UIButton!
    var deleteButton: UIButton!
    var budgetID: Int!
    var tagID: Int!
    var index: Int!
    
    weak var delegate: pushModallyDelegate?
    
    let buttonWidth = 120
    let buttonHeight = 45
    
    init(for budget: Budget, index: Int) {
        categoryString = Statics.categories[budget.tag_id]
        amountString = String(budget.limit)
        budgetID = budget.budget_id
        tagID = budget.tag_id
        self.index = index
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        view.layer.cornerRadius = 40
        
        self.preferredContentSize = CGSize(width: view.frame.width, height: 50)

        editBudgetLabel = UILabel()
        editBudgetLabel.text = "Edit " + categoryString + " Budget"
        editBudgetLabel.textAlignment = .center
        editBudgetLabel.textColor = .main
        editBudgetLabel.font = .systemFont(ofSize: 27, weight: .medium)
        view.addSubview(editBudgetLabel)
        
        amountPerMonthLabel = UILabel()
        amountPerMonthLabel.text = "Amount Per Month"
        amountPerMonthLabel.textAlignment = .center
        amountPerMonthLabel.textColor = .main
        amountPerMonthLabel.font = .systemFont(ofSize: 22, weight: .medium)
        view.addSubview(amountPerMonthLabel)
        
        amountTextField = UITextField()
        amountTextField.attributedPlaceholder = NSAttributedString(string: "$" + amountString,
                                                                   attributes: [NSAttributedString.Key.foregroundColor: UIColor.meta])
        amountTextField.textColor = .secondary
        amountTextField.font = .systemFont(ofSize: 50, weight: .medium)
        view.addSubview(amountTextField)
        
        saveButton = UIButton()
        saveButton.setTitle("Save", for: .normal)
        saveButton.layer.cornerRadius = 10
        saveButton.setTitleColor(.white, for: .normal)
        saveButton.contentHorizontalAlignment = .center
        saveButton.contentVerticalAlignment = .center
        saveButton.backgroundColor = .accentGreen
        saveButton.titleLabel?.font = .systemFont(ofSize: 18, weight: .medium)
        saveButton.addTarget(self, action: #selector(saveBudget), for: .touchUpInside)
        view.addSubview(saveButton)
        
        deleteButton = UIButton()
        deleteButton.setTitle("Delete", for: .normal)
        deleteButton.layer.cornerRadius = 10
        deleteButton.setTitleColor(.white, for: .normal)
        deleteButton.contentHorizontalAlignment = .center
        deleteButton.contentVerticalAlignment = .center
        deleteButton.titleLabel?.font = .systemFont(ofSize: 18, weight: .medium)
        deleteButton.backgroundColor = UIColor(red: 1, green: 0.5686, blue: 0.5686, alpha: 1.0)
        deleteButton.addTarget(self, action: #selector(deleteBudget), for: .touchUpInside)
        view.addSubview(deleteButton)

        setupConstraints()
    }
    
    func setupConstraints() {
        editBudgetLabel.snp.makeConstraints { make in
            make.top.equalTo(view).offset(80)
            make.centerX.equalTo(view)
        }
        amountPerMonthLabel.snp.makeConstraints { make in
            make.top.equalTo(editBudgetLabel.snp.bottom).offset(30)
            make.centerX.equalTo(editBudgetLabel)
        }
        amountTextField.snp.makeConstraints { make in
            make.top.equalTo(amountPerMonthLabel.snp.bottom).offset(20)
            make.centerX.equalTo(editBudgetLabel)
        }
        
        saveButton.snp.makeConstraints { make in
            make.width.equalTo(buttonWidth)
            make.height.equalTo(buttonHeight)
            make.right.equalTo(view.snp.centerX).offset(-10)
            make.top.equalTo(amountTextField.snp.bottom).offset(40)
        }
        
        deleteButton.snp.makeConstraints { make in
            make.width.equalTo(buttonWidth)
            make.height.equalTo(buttonHeight)
            make.left.equalTo(view.snp.centerX).offset(10)
            make.top.equalTo(saveButton)
        }
        
    }
    
    @objc func saveBudget() {
        if let editedAmount = amountTextField.text, let editedAmountInt = Int(editedAmount) {
            NetworkManager.editBudget(budgetID: budgetID, limit: editedAmount, tagID: tagID) {
                print("budget sucessfully edited")
            }
            let newBudget = Budget(budget_id: budgetID, limit: editedAmountInt, tag_id: tagID)
            delegate?.editBudget(budget: newBudget, index: index)
            dismiss(animated: true, completion: nil)
        }
    }
   
    
    @objc func deleteBudget() {
        NetworkManager.deleteBudget(budgetID: budgetID) {
            print("budget successfully deleted")
        }
        delegate?.deleteBudget(index: index)
        dismiss(animated: true, completion: nil)
    }

}
