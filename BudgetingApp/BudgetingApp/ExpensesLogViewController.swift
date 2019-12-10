//
//  ExpensesLogViewController.swift
//  BudgetingApp
//
//  Created by Janice Jung on 11/20/19.
//  Copyright © 2019 Janice Jung. All rights reserved.
//

import UIKit

protocol UpdateExpensesDelegate: class {
    func pushAddExpense()
    func filter(for: String?)
    func deleteExpense(index: Int)
    func createExpense(expense: Expense)
    func editExpense(expense: Expense, index: Int)
}



class ExpensesLogViewController: UIViewController {
    

    
    var expenseCollectionView: UICollectionView!
    let ExpenseCellReuseIdentifier = "expenseCellReuseIdentifier"
    let ExpenseHeaderReuseIdentifier = "ExpenseHeaderReuseIdentifier"
    
    let headerHeight: CGFloat = 400
    
    var titleLabel: UILabel!
    var titleBackground: UILabel!
    
    var expenses: [Expense] = []
    var visibleExpenses: [Expense] = []

    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        
        view.backgroundColor = .background
        title = "Expenses"
        
        titleBackground = UILabel()
        titleBackground.backgroundColor = .accentGreen
        view.addSubview(titleBackground)
        
        titleLabel = UILabel()
        titleLabel.backgroundColor = .accentGreen
        titleLabel.text = "Expenses 💸"
        titleLabel.font = .systemFont(ofSize: 33, weight: .medium)
        titleLabel.textAlignment = .center
        titleLabel.layer.cornerRadius = 25
        titleLabel.layer.masksToBounds = true;
        titleLabel.textColor = .white
        view.addSubview(titleLabel)
        
        
        let expenseLayout = UICollectionViewFlowLayout()
        expenseLayout.scrollDirection = .vertical
        expenseLayout.minimumLineSpacing = CGFloat(8)
        expenseLayout.minimumInteritemSpacing = CGFloat(8)

        
        expenseCollectionView = UICollectionView(frame: .zero, collectionViewLayout: expenseLayout)
        expenseCollectionView.backgroundColor = .background
        expenseCollectionView.register(ExpenseCollectionViewCell.self, forCellWithReuseIdentifier: ExpenseCellReuseIdentifier)
        expenseCollectionView.register(ExpenseHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: ExpenseHeaderReuseIdentifier)
        expenseCollectionView.showsVerticalScrollIndicator = false
        expenseCollectionView.dataSource = self
        expenseCollectionView.delegate = self
        view.addSubview(expenseCollectionView)
        
        setupConstraints()
        getExpenses()
    }
    
    func setupConstraints() {
        
        titleLabel.snp.makeConstraints { make in
            make.top.left.right.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(100)
        }
        
        titleBackground.snp.makeConstraints { make in
            make.top.left.right.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(50)
        }
        
//        categoryCollectionView.snp.makeConstraints { make in
//            make.top.equalTo(titleLabel.snp.bottom).offset(0)
//            make.left.right.equalTo(view.safeAreaLayoutGuide).offset(20)
//            //make.centerX.equalTo(view)
//            make.height.equalTo(80)
//        }
        
        expenseCollectionView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom)
            make.left.right.bottom.equalTo(view.safeAreaLayoutGuide).inset(UIEdgeInsets(top: 0, left: 20, bottom: 20, right: 20))
        }
        
    }

    
    func getExpenses() {
        let user = Statics.user!
        print("printing user now")
        print(user)
        NetworkManager.getExpensesForUser(userID: user.user_id) { expenses in
            self.expenses = expenses
            self.visibleExpenses = expenses
            print(self.expenses)
            print(expenses)
            print("done getting expenses")
            DispatchQueue.main.async {
                self.expenseCollectionView.reloadData()
            }
        }
    }
    
//    func getUsers() {
//        NetworkManager.getUsers { users in
//            self.users = users
//            print(self.users)
//            print("Done")
//        }
//    }

}

extension ExpensesLogViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        if collectionView == categoryCollectionView {
//            return categories.count
//        } else {
        return visibleExpenses.count
//        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
//        if collectionView == expenseCollectionView {
        let expense = visibleExpenses[indexPath.row]
        print(expense)
        let cell = expenseCollectionView.dequeueReusableCell(withReuseIdentifier: ExpenseCellReuseIdentifier, for: indexPath) as! ExpenseCollectionViewCell
        cell.configure(for: expense)
        return cell
//        } else {
//            let category = categories[indexPath.row]
//            let cell = categoryCollectionView.dequeueReusableCell(withReuseIdentifier: CategoryCellReuseIdentifier, for: indexPath) as! CategoryCollectionViewCell
//            cell.configure(for: category)
//            return cell
//        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        if collectionView == categoryCollectionView {
//            let selectedCell = categoryCollectionView.cellForItem(at: indexPath) as! CategoryCollectionViewCell
//            let category = categories[indexPath.row]
//            if selectedCategory != category {
//                selectedCategory = category
//            } else {
//                selectedCategory = nil
//            }
//            delegate.filter(for: selectedCategory)
//        }
        
        let expense = visibleExpenses[indexPath.row]
        let viewController = EditExpenseViewController()
        viewController.delegate = self
        viewController.expense = expense
        viewController.index = indexPath.row
        navigationController?.present(viewController, animated: true, completion: nil)

    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let expenseHeaderView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: ExpenseHeaderReuseIdentifier, for: indexPath) as! ExpenseHeaderView

//        if collectionView == expenseCollectionView {
        expenseHeaderView.delegate = self
        return expenseHeaderView
//        } else {
//            expenseHeaderView.frame.size.height = 0.0
//            expenseHeaderView.frame.size.width = 0.0
//            return expenseHeaderView
//        }
        
        
    }
    
//    func filter(for filter: String?) {
//        visibleExpenses = []
//        if let unwrappedFilter = filter {
//            for expense in expenses {
//                if expense.category == unwrappedFilter {
//                    visibleExpenses.append(expense)
//                }
//            }
//        } else {
//            visibleExpenses = expenses
//        }
//        expenseCollectionView.reloadData()
//    }
//
    
}

extension ExpensesLogViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
       
//        if collectionView == expenseCollectionView {
            let width = collectionView.frame.width
            return CGSize(width: width, height: 120)
//        } else {
//            let label = UILabel(frame: CGRect.zero)
//            label.text = categories[indexPath.row]
//            label.sizeToFit()
//            return CGSize(width: label.frame.width+20, height: 32)
//        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        return CGSize(width: collectionView.frame.width, height: headerHeight)

    }
}

extension ExpensesLogViewController: UpdateExpensesDelegate {
    
    func filter(for filter: String?) {
        visibleExpenses = []
        if let unwrappedFilter = filter {
            for expense in expenses {
                if Statics.categories[expense.tag] == unwrappedFilter {
                    visibleExpenses.append(expense)
                }
            }
        } else {
            visibleExpenses = expenses
        }
        expenseCollectionView.reloadData()
    }
        
    func createExpense(expense: Expense) {
        expenses.append(expense)
        visibleExpenses.append(expense)
        expenseCollectionView.reloadData()
    }
    
    func editExpense(expense: Expense, index: Int) {
        for i in 0..<expenses.count {
            if expenses[i].expense_id == visibleExpenses[index].expense_id {
                expenses[i] = expense
                break
            }
        }
        visibleExpenses[index] = expense
        expenseCollectionView.reloadData()
    }
    
    func deleteExpense(index: Int) {
        for i in 0..<expenses.count {
            if expenses[i].expense_id == visibleExpenses[index].expense_id {
                expenses.remove(at: i)
                break
            }
        }
        visibleExpenses.remove(at: index)
        expenseCollectionView.reloadData()
    }
    
    func pushAddExpense() {
        let viewController = AddExpenseViewController()
        viewController.delegate = self
        navigationController?.present(viewController, animated: true, completion: nil)
    }


}


