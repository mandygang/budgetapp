//
//  MyBudgetsViewController.swift
//  BudgetingApp
//
//  Created by Janice Jung on 11/20/19.
//  Copyright © 2019 Janice Jung. All rights reserved.
//

import UIKit
import SnapKit

protocol pushModallyDelegate: class {
    func pushSetBudgetViewController(for: SetBudgetViewController)
    func deleteBudget(index: Int)
    func createBudget(budget: Budget)
    func editBudget(budget: Budget, index: Int)
}


class MyBudgetsViewController: UIViewController {
    
    var budgetCollectionView: UICollectionView!
    var budgets: [Budget] = []
    var titleLabel: UILabel!
    var addButton: UIButton!
    var titleBackground: UILabel!
    
    let budgetCellReuseIdentifier = "budgetCellReuseIdentifier"
    let budgetHeaderReuseIdentifier = "budgetHeaderReuseIdentifier"
    let headerHeight = CGFloat(175)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        addButton = UIButton()
//        addButton.
//        addButton.target = self
//        addButton.action = #selector(pushSetBudgetViewController)
//        navigationItem.rightBarButtonItem = addButton
        
//        let budget1 = Budget(category: "Food", amount: "300")
//        let budget2 = Budget(category: "Groceries", amount: "500")
//        let budget3 = Budget(category: "Shopping", amount: "200")
//        let budget4 = Budget(category: "Entertainment", amount: "100")
//        let budget5 = Budget(category: "Groceries", amount: "500")
//        let budget6 = Budget(category: "Transport", amount: "50")
        
//        budgets = [budget1, budget2, budget3, budget4, budget5, budget6]

        
        view.backgroundColor = .background
        
        titleBackground = UILabel()
        titleBackground.backgroundColor = .accentGreen
        view.addSubview(titleBackground)
        
        titleLabel = UILabel()
        titleLabel.backgroundColor = .accentGreen
        titleLabel.text = "Budgets 🏦"
        titleLabel.font = .systemFont(ofSize: 33, weight: .medium)
        titleLabel.textAlignment = .center
        titleLabel.layer.cornerRadius = 25
        titleLabel.layer.masksToBounds = true;
        titleLabel.textColor = .white
        view.addSubview(titleLabel)
        
        let budgetLayout = UICollectionViewFlowLayout()
        budgetLayout.scrollDirection = .vertical
        budgetLayout.minimumLineSpacing = CGFloat(25)
        budgetLayout.minimumInteritemSpacing = CGFloat(8)
        
        budgetCollectionView = UICollectionView(frame: .zero, collectionViewLayout: budgetLayout)
        budgetCollectionView.backgroundColor = .background
        budgetCollectionView.register(MyBudgetsCollectionViewCell.self, forCellWithReuseIdentifier: budgetCellReuseIdentifier)
        budgetCollectionView.register(BudgetsHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: budgetHeaderReuseIdentifier)
        budgetCollectionView.showsVerticalScrollIndicator = false
        budgetCollectionView.dataSource = self
        budgetCollectionView.delegate = self
        view.addSubview(budgetCollectionView)
        
        setupConstraints()
        getAllBudgets()
        
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
        
        budgetCollectionView.snp.makeConstraints { make in
            make.left.bottom.right.equalTo(view.safeAreaLayoutGuide).inset(UIEdgeInsets(top:0, left: 25, bottom: 20, right: 25))
            make.top.equalTo(titleLabel.snp.bottom)
        }
        
    }
    
    func getAllBudgets() {
        let user = Statics.user!
        NetworkManager.getBudgets(userID: user.user_id) { budgets in
            self.budgets = budgets
            print(budgets)
            print("done getting all budgets")
            DispatchQueue.main.async {
                self.budgetCollectionView.reloadData()
            }
        }
        
    }

}

extension MyBudgetsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return budgets.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = budgetCollectionView.dequeueReusableCell(withReuseIdentifier: budgetCellReuseIdentifier, for: indexPath) as! MyBudgetsCollectionViewCell
        
        cell.configure(for: budgets[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: budgetHeaderReuseIdentifier, for: indexPath) as! BudgetsHeaderView
        headerView.delegate = self
        return headerView
    }
}

extension MyBudgetsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width
        return CGSize(width: width, height: 120)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let width = collectionView.frame.width
        return CGSize(width: width, height: headerHeight)
    }
    
}

extension MyBudgetsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let budget = budgets[indexPath.row]
        let editBudgetViewController = EditBudgetViewController(for: budget, index: indexPath.row)
        
        editBudgetViewController.definesPresentationContext = true
        editBudgetViewController.modalPresentationStyle = .popover
        editBudgetViewController.delegate = self
        navigationController?.present(editBudgetViewController, animated: true, completion: nil)

    }
}

extension MyBudgetsViewController: pushModallyDelegate {
    func editBudget(budget: Budget, index: Int) {
        budgets[index] = budget
        budgetCollectionView.reloadData()
        print(budgets)
    }
    
    func createBudget(budget: Budget) {
        budgets.append(budget)
        budgetCollectionView.reloadData()
    }
    
    func deleteBudget(index: Int) {
        budgets.remove(at: index)
        budgetCollectionView.reloadData()
    }
    
    func pushSetBudgetViewController(for view: SetBudgetViewController) {
        present(view, animated: true, completion: nil)
    }
    
    
}

