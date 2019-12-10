//
//  EditExpenseViewController.swift
//  BudgetingApp
//
//  Created by Janice Jung on 12/8/19.
//  Copyright © 2019 Janice Jung. All rights reserved.
//

import UIKit

class EditExpenseViewController: UIViewController {

    var amountLabel: UILabel!
    var selectCategoryLabel: UILabel!
    var amountTextField: UITextField!
    var titleTextField: UITextField!
    var descriptionTextField: UITextField!
    var foodButton: UIButton!
    var entertainmentButton: UIButton!
    var billsButton: UIButton!
    var groceriesButton: UIButton!
    var shopButton: UIButton!
    var transportButton: UIButton!
    var otherButton: UIButton!
    var saveButton: UIButton!
    var deleteButton: UIButton!
    
    var expense: Expense!
    var index: Int!
    
    var selectedCategory: Int?

    weak var delegate: UpdateExpensesDelegate?
        
    let buttonWidth = 150
    let buttonHeight = 40
    let padding = 20
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround() 

        view.backgroundColor = .white
        view.layer.cornerRadius = 40

        selectCategoryLabel = UILabel()
        selectCategoryLabel.text = "Select Category"
        selectCategoryLabel.textAlignment = .center
        selectCategoryLabel.textColor = .main
        selectCategoryLabel.font = .systemFont(ofSize: 23, weight: .medium)
        view.addSubview(selectCategoryLabel)
        
        titleTextField = UITextField()
        titleTextField.attributedPlaceholder = NSAttributedString(string: "Title", attributes: [NSAttributedString.Key.foregroundColor: UIColor.meta])
        titleTextField.textColor = .secondary
        titleTextField.font = .systemFont(ofSize: 30, weight: .medium)
        view.addSubview(titleTextField)
        
        descriptionTextField = UITextField()
        descriptionTextField.attributedPlaceholder = NSAttributedString(string: "Description", attributes: [NSAttributedString.Key.foregroundColor: UIColor.meta])
        descriptionTextField.textColor = .secondary
        descriptionTextField.font = .systemFont(ofSize: 20, weight: .medium)
        view.addSubview(descriptionTextField)
            
        amountLabel = UILabel()
        amountLabel.text = "Amount"
        amountLabel.textAlignment = .center
        amountLabel.textColor = .main
        amountLabel.font = .systemFont(ofSize: 25, weight: .medium)
        view.addSubview(amountLabel)
            
        amountTextField = UITextField()
        amountTextField.attributedPlaceholder = NSAttributedString(string: "$0.00", attributes: [NSAttributedString.Key.foregroundColor: UIColor.meta])
        amountTextField.textColor = .secondary
        amountTextField.font = .systemFont(ofSize: 50, weight: .medium)
        view.addSubview(amountTextField)
            
        foodButton = UIButton()
        foodButton.layer.masksToBounds = true
        foodButton.setTitle("Food", for: .normal)
        foodButton.layer.cornerRadius = CGFloat(buttonHeight/2)
        foodButton.layer.borderWidth = 2
        foodButton.layer.borderColor = UIColor.secondary.cgColor
        foodButton.setTitleColor(.secondary, for: .normal)
        foodButton.setTitleColor(.white, for: .selected)
        foodButton.titleLabel?.font = .systemFont(ofSize: 18, weight: .medium)
        foodButton.contentHorizontalAlignment = .center
        foodButton.contentVerticalAlignment = .center
        foodButton.setBackgroundImage(UIImage(named: "white"), for: .normal)
        foodButton.setBackgroundImage(UIImage(named: "secondary"), for: .selected)
        foodButton.addTarget(self, action: #selector(foodButtonPressed), for: .touchUpInside)
        view.addSubview(foodButton)
            
        entertainmentButton = UIButton()
        entertainmentButton.layer.masksToBounds = true
        entertainmentButton.setTitle("Entertainment", for: .normal)
        entertainmentButton.layer.cornerRadius = CGFloat(buttonHeight/2)
        entertainmentButton.layer.borderWidth = 2
        entertainmentButton.layer.borderColor = UIColor.secondary.cgColor
        entertainmentButton.setTitleColor(.secondary, for: .normal)
        entertainmentButton.setTitleColor(.white, for: .selected)
        entertainmentButton.titleLabel?.font = .systemFont(ofSize: 18, weight: .medium)
        entertainmentButton.contentHorizontalAlignment = .center
        entertainmentButton.contentVerticalAlignment = .center
        entertainmentButton.setBackgroundImage(UIImage(named: "white"), for: .normal)
        entertainmentButton.setBackgroundImage(UIImage(named: "secondary"), for: .selected)
        entertainmentButton.addTarget(self, action: #selector(entertainmentButtonPressed), for: .touchUpInside)
        view.addSubview(entertainmentButton)
        
        billsButton = UIButton()
        billsButton.layer.masksToBounds = true
        billsButton.setTitle("Bills", for: .normal)
        billsButton.layer.cornerRadius = CGFloat(buttonHeight/2)
        billsButton.layer.borderWidth = 2
        billsButton.layer.borderColor = UIColor.secondary.cgColor
        billsButton.setTitleColor(.secondary, for: .normal)
        billsButton.titleLabel?.font = .systemFont(ofSize: 18, weight: .medium)
        billsButton.setTitleColor(.white, for: .selected)
        billsButton.contentHorizontalAlignment = .center
        billsButton.contentVerticalAlignment = .center
        billsButton.setBackgroundImage(UIImage(named: "white"), for: .normal)
        billsButton.setBackgroundImage(UIImage(named: "secondary"), for: .selected)
        billsButton.addTarget(self, action: #selector(billsButtonPressed), for: .touchUpInside)
        view.addSubview(billsButton)
        
        groceriesButton = UIButton()
        groceriesButton.layer.masksToBounds = true
        groceriesButton.setTitle("Groceries", for: .normal)
        groceriesButton.layer.cornerRadius = CGFloat(buttonHeight/2)
        groceriesButton.layer.borderWidth = 2
        groceriesButton.layer.borderColor = UIColor.secondary.cgColor
        groceriesButton.setTitleColor(.secondary, for: .normal)
        groceriesButton.setTitleColor(.white, for: .selected)
        groceriesButton.titleLabel?.font = .systemFont(ofSize: 18, weight: .medium)
        groceriesButton.contentHorizontalAlignment = .center
        groceriesButton.contentVerticalAlignment = .center
        groceriesButton.setBackgroundImage(UIImage(named: "white"), for: .normal)
        groceriesButton.setBackgroundImage(UIImage(named: "secondary"), for: .selected)
        groceriesButton.addTarget(self, action: #selector(groceriesButtonPressed), for: .touchUpInside)
        view.addSubview(groceriesButton)
        
        shopButton = UIButton()
        shopButton.layer.masksToBounds = true
        shopButton.setTitle("Shop", for: .normal)
        shopButton.layer.cornerRadius = CGFloat(buttonHeight/2)
        shopButton.layer.borderWidth = 2
        shopButton.layer.borderColor = UIColor.secondary.cgColor
        shopButton.setTitleColor(.secondary, for: .normal)
        shopButton.setTitleColor(.white, for: .selected)
        shopButton.contentHorizontalAlignment = .center
        shopButton.titleLabel?.font = .systemFont(ofSize: 18, weight: .medium)
        shopButton.contentVerticalAlignment = .center
        shopButton.setBackgroundImage(UIImage(named: "white"), for: .normal)
        shopButton.setBackgroundImage(UIImage(named: "secondary"), for: .selected)
        shopButton.addTarget(self, action: #selector(shopButtonPressed), for: .touchUpInside)
        view.addSubview(shopButton)
        
        transportButton = UIButton()
        transportButton.layer.masksToBounds = true
        transportButton.setTitle("Transport", for: .normal)
        transportButton.layer.cornerRadius = CGFloat(buttonHeight/2)
        transportButton.layer.borderWidth = 2
        transportButton.layer.borderColor = UIColor.secondary.cgColor
        transportButton.setTitleColor(.secondary, for: .normal)
        transportButton.setTitleColor(.white, for: .selected)
        transportButton.contentHorizontalAlignment = .center
        transportButton.titleLabel?.font = .systemFont(ofSize: 18, weight: .medium)
        transportButton.contentVerticalAlignment = .center
        transportButton.setBackgroundImage(UIImage(named: "white"), for: .normal)
        transportButton.setBackgroundImage(UIImage(named: "secondary"), for: .selected)
        transportButton.addTarget(self, action: #selector(transportButtonPressed), for: .touchUpInside)
        view.addSubview(transportButton)
        
        otherButton = UIButton()
        otherButton.layer.masksToBounds = true
        otherButton.setTitle("Other", for: .normal)
        otherButton.layer.cornerRadius = CGFloat(buttonHeight/2)
        otherButton.layer.borderWidth = 2
        otherButton.layer.borderColor = UIColor.secondary.cgColor
        otherButton.setTitleColor(.secondary, for: .normal)
        otherButton.setTitleColor(.white, for: .selected)
        otherButton.contentHorizontalAlignment = .center
        otherButton.titleLabel?.font = .systemFont(ofSize: 18, weight: .medium)
        otherButton.contentVerticalAlignment = .center
        otherButton.setBackgroundImage(UIImage(named: "white"), for: .normal)
        otherButton.setBackgroundImage(UIImage(named: "secondary"), for: .selected)
        otherButton.addTarget(self, action: #selector(otherButtonPressed), for: .touchUpInside)
        view.addSubview(otherButton)
        
        saveButton = UIButton()
        saveButton.setTitle("Save", for: .normal)
        saveButton.layer.cornerRadius = CGFloat(buttonHeight/3)
        saveButton.layer.borderWidth = 2
        saveButton.layer.borderColor = UIColor.accentGreen.cgColor
        saveButton.setTitleColor(.white, for: .normal)
        saveButton.titleLabel?.font = .systemFont(ofSize: 25, weight: .medium)
        saveButton.contentHorizontalAlignment = .center
        saveButton.contentVerticalAlignment = .center
        saveButton.backgroundColor = .accentGreen
        saveButton.addTarget(self, action: #selector(saveButtonPressed), for: .touchUpInside)
        view.addSubview(saveButton)
        
        deleteButton = UIButton()
        deleteButton.setTitle("Delete", for: .normal)
        deleteButton.layer.cornerRadius = CGFloat(buttonHeight/3)
        deleteButton.layer.borderWidth = 2
        deleteButton.layer.borderColor = UIColor.accentGreen.cgColor
        deleteButton.setTitleColor(.white, for: .normal)
        deleteButton.titleLabel?.font = .systemFont(ofSize: 25, weight: .medium)
        deleteButton.contentHorizontalAlignment = .center
        deleteButton.contentVerticalAlignment = .center
        deleteButton.backgroundColor = UIColor(red: 1, green: 0.5686, blue: 0.5686, alpha: 1.0)
        deleteButton.addTarget(self, action: #selector(deleteButtonPressed), for: .touchUpInside)
        view.addSubview(deleteButton)

        setupConstraints()
        
    }
    
    func setupConstraints() {
        selectCategoryLabel.snp.makeConstraints { make in
            make.top.equalTo(view).offset(80)
            make.centerX.equalTo(view)
        }
        
        foodButton.snp.makeConstraints { make in
            make.top.equalTo(selectCategoryLabel.snp.bottom).offset(padding)
            make.right.equalTo(view.snp.centerX).offset(-10)
            make.width.equalTo(buttonWidth)
            make.height.equalTo(buttonHeight)
        }
        
        entertainmentButton.snp.makeConstraints { make in
            make.top.equalTo(foodButton)
            make.left.equalTo(view.snp.centerX).offset(10)
            make.width.equalTo(buttonWidth)
            make.height.equalTo(buttonHeight)
        }
        
        billsButton.snp.makeConstraints { make in
            make.top.equalTo(foodButton.snp.bottom).offset(padding)
            make.right.equalTo(view.snp.centerX).offset(-10)
            make.width.equalTo(buttonWidth)
            make.height.equalTo(buttonHeight)
        }
        
        groceriesButton.snp.makeConstraints { make in
            make.top.equalTo(billsButton)
            make.left.equalTo(view.snp.centerX).offset(10)
            make.width.equalTo(buttonWidth)
            make.height.equalTo(buttonHeight)
        }
        
        shopButton.snp.makeConstraints { make in
            make.top.equalTo(billsButton.snp.bottom).offset(padding)
            make.right.equalTo(view.snp.centerX).offset(-10)
            make.width.equalTo(buttonWidth)
            make.height.equalTo(buttonHeight)
        }
        
        transportButton.snp.makeConstraints { make in
            make.top.equalTo(shopButton)
            make.left.equalTo(view.snp.centerX).offset(10)
            make.width.equalTo(buttonWidth)
            make.height.equalTo(buttonHeight)
        }
        
        otherButton.snp.makeConstraints { make in
            make.top.equalTo(shopButton.snp.bottom).offset(padding)
            make.centerX.equalTo(view.snp.centerX)
            make.width.equalTo(buttonWidth)
            make.height.equalTo(buttonHeight)
        }
        
        titleTextField.snp.makeConstraints { make in
            make.top.equalTo(otherButton.snp.bottom).offset(80)
            make.centerX.equalTo(view)
        }
        
        amountLabel.snp.makeConstraints { make in
            make.top.equalTo(titleTextField.snp.bottom).offset(20)
            make.centerX.equalTo(view)
        }
        amountTextField.snp.makeConstraints { make in
            make.top.equalTo(amountLabel.snp.bottom).offset(20)
            make.centerX.equalTo(view)
        }
        
        descriptionTextField.snp.makeConstraints { make in
            make.top.equalTo(amountTextField.snp.bottom).offset(20)
            make.centerX.equalTo(view)
            make.height.equalTo(100)
        }
        
        saveButton.snp.makeConstraints { make in
            make.width.equalTo(90)
            make.height.equalTo(60)
            make.right.equalTo(view.snp.centerX).offset(-10)
            make.top.equalTo(descriptionTextField.snp.bottom).offset(40)
        }
        
        deleteButton.snp.makeConstraints { make in
            make.width.equalTo(90)
            make.height.equalTo(60)
            make.left.equalTo(view.snp.centerX).offset(10)
            make.top.equalTo(descriptionTextField.snp.bottom).offset(40)
        }
        
    }

    @objc func foodButtonPressed() {
        if foodButton.isSelected {
            foodButton.isSelected = false
            selectedCategory = nil
        } else {
            foodButton.isSelected = true
            entertainmentButton.isSelected = false
            billsButton.isSelected = false
            groceriesButton.isSelected = false
            shopButton.isSelected = false
            transportButton.isSelected = false
            otherButton.isSelected = false
            selectedCategory = 0
        }
    }

    @objc func entertainmentButtonPressed() {
        if entertainmentButton.isSelected {
            entertainmentButton.isSelected = false
            selectedCategory = nil
        } else {
            entertainmentButton.isSelected = true
            foodButton.isSelected = false
            billsButton.isSelected = false
            groceriesButton.isSelected = false
            shopButton.isSelected = false
            transportButton.isSelected = false
            otherButton.isSelected = false
            selectedCategory = 1
        }
    }

    @objc func billsButtonPressed() {
        if billsButton.isSelected {
            billsButton.isSelected = false
            selectedCategory = nil
        } else {
            billsButton.isSelected = true
            entertainmentButton.isSelected = false
            foodButton.isSelected = false
            groceriesButton.isSelected = false
            shopButton.isSelected = false
            transportButton.isSelected = false
            otherButton.isSelected = false
            selectedCategory = 2
        }
    }

    @objc func groceriesButtonPressed() {
        if groceriesButton.isSelected {
            groceriesButton.isSelected = false
            selectedCategory = nil
        } else {
            groceriesButton.isSelected = true
            billsButton.isSelected = false
            entertainmentButton.isSelected = false
            foodButton.isSelected = false
            shopButton.isSelected = false
            transportButton.isSelected = false
            otherButton.isSelected = false
            selectedCategory = 3
            
        }
    }

    @objc func shopButtonPressed() {
        if shopButton.isSelected {
            shopButton.isSelected = false
            selectedCategory = nil
        } else {
            shopButton.isSelected = true
            groceriesButton.isSelected = false
            billsButton.isSelected = false
            entertainmentButton.isSelected = false
            foodButton.isSelected = false
            transportButton.isSelected = false
            otherButton.isSelected = false
            selectedCategory = 4
            
        }
    }

    @objc func transportButtonPressed() {
        if transportButton.isSelected {
            transportButton.isSelected = false
            selectedCategory = nil
        } else {
            transportButton.isSelected = true
            shopButton.isSelected = false
            groceriesButton.isSelected = false
            billsButton.isSelected = false
            entertainmentButton.isSelected = false
            foodButton.isSelected = false
            otherButton.isSelected = false
            selectedCategory = 5
        }
    }

    @objc func otherButtonPressed() {
        if otherButton.isSelected {
            otherButton.isSelected = false
            selectedCategory = nil
        } else {
            otherButton.isSelected = true
            transportButton.isSelected = false
            shopButton.isSelected = false
            groceriesButton.isSelected = false
            billsButton.isSelected = false
            entertainmentButton.isSelected = false
            foodButton.isSelected = false
            selectedCategory = 6
        }
    }
    
    @objc func saveButtonPressed() {
        if let tag = selectedCategory, let limitString = amountTextField.text {
            print(tag)
            print(limitString)
            if let title = titleTextField.text, let amount = amountTextField.text, let description = descriptionTextField.text {
                    NetworkManager.editExpense(expenseID: expense.expense_id, title: title, amount: amount, description: description, date: "10/10/10", tag: tag) { expense in
                    self.delegate?.editExpense(expense: expense, index: self.index)
                    print("successfully edited expense")
                    self.dismiss(animated: true, completion: nil)
                }
                
            }
        }
    }
    
    @objc func deleteButtonPressed() {
                
        NetworkManager.deleteExpense(expenseID: expense.expense_id) {
            self.delegate?.deleteExpense(index: self.index)
            print("successfully deleted expense")
            self.dismiss(animated: true, completion: nil)
        }
                
    }
}


