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

//protocol UpdateExpensesDelegate: class {
//    func deleteExpense(index: Int)
//    func createExpense(expense: Expense)
//    func editExpense(expense: Expense, index: Int)
//}

class ExpensesLogViewController: UIViewController {
    
//    var categoryCollectionView: UICollectionView!
//    let CategoryCellReuseIdentifier = "categoryCellReuseIdentifier"
//    var categories: [String] = []
//    var selectedCategory: String?
    
    
    var expenseCollectionView: UICollectionView!
    let ExpenseCellReuseIdentifier = "expenseCellReuseIdentifier"
    let ExpenseHeaderReuseIdentifier = "ExpenseHeaderReuseIdentifier"
    
    let headerHeight: CGFloat = 600
    
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
        
//        categories = ["Food", "Entertainment", "Bills", "Groceries", "Shop", "Transport", "Other"]
//
//        let categoryLayout = UICollectionViewFlowLayout()
//        categoryLayout.scrollDirection = .horizontal
//        categoryLayout.minimumLineSpacing = CGFloat(8)
//        categoryLayout.minimumInteritemSpacing = CGFloat(8)
//
//        categoryCollectionView = UICollectionView(frame: .zero, collectionViewLayout: categoryLayout)
//        categoryCollectionView.backgroundColor = .white
//        categoryCollectionView.register(CategoryCollectionViewCell.self, forCellWithReuseIdentifier: CategoryCellReuseIdentifier)
//        categoryCollectionView.showsHorizontalScrollIndicator = false
//        categoryCollectionView.dataSource = self
//        categoryCollectionView.delegate = self
//        view.addSubview(categoryCollectionView)
        
//        let expense1 = Expense(category: "Food", amount: "14", note: "Farmer's market")
//        let expense2 = Expense(category: "Food", amount: "30", note: "Oyster bar")
//        let expense3 = Expense(category: "Entertainment", amount: "20", note: "Movie")
//        let expense4 = Expense(category: "Bills", amount: "100", note: "Phone bill")
//        let expense5 = Expense(category: "Groceries", amount: "60", note: "Target run!")
//        let expense6 = Expense(category: "Groceries", amount: "30", note: "Annabel's")
//        let expense7 = Expense(category: "Shop", amount: "500", note: "Black friday  shopping")
//        let expense8 = Expense(category: "Transport", amount: "10", note: "Gas")
//        let expense9 = Expense(category: "Other", amount: "40", note: "Parking ticket")
//        let expense10 = Expense(category: "Other", amount: "20", note: "Donations")
//        
//        expenses = [expense1, expense2, expense3, expense4, expense5, expense6, expense7, expense8, expense9, expense10]
//        visibleExpenses = [expense1, expense2, expense3, expense4, expense5, expense6, expense7, expense8, expense9, expense10]
        
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
        NetworkManager.getExpensesForUser(userID: 1) { expenses in
            self.expenses = expenses
            self.visibleExpenses = expenses
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
            return CGSize(width: width, height: 200)
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


//    func deleteExpense(index: Int) {
//        let expense = visibleExpenses[index]
//        expenses.firstIndex { expense -> Bool in
//            if expense ==
//        //}
//
//        visibleExpenses.remove(at: index)
//        expenseCollectionView.reloadData()
//    }
//extension ExpensesLogViewController: UpdateExpensesDelegate {
//    func deleteExpense(index: Int) {
//        //expenses.firstIndex(where: <#T##(Expense) throws -> Bool#>)
//        visibleExpenses.remove(at: index)
//        expenseCollectionView.reloadData()
//    }
//
//    func createExpense(expense: Expense) {
//        expenses.append(expense)
//        visibleExpenses.append(expense)
//        expenseCollectionView.reloadData()
//    }
//
//    func editExpense(expense: Expense, index: Int) {
//        visibleExpenses[index] = expense
//        expenseCollectionView.reloadData()
//    }
//
//
//}
