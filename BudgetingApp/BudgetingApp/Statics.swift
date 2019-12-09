//
//  Statics.swift
//  BudgetingApp
//
//  Created by Janice Jung on 12/8/19.
//  Copyright © 2019 Janice Jung. All rights reserved.
//

import Foundation

struct Statics {
    static let categories: [String] = ["Food", "Entertainment", "Bills", "Groceries", "Shop", "Transport", "Other"]
    
    static var user: User?
    
    static func getTotalExpenses(expenses: [Expense]) -> Float {
        var total: Float = 0
        for expense in expenses {
            total += expense.amount
        }
        return total
    }
    
    static func getTotalBudget(budgets: [Budget]) -> Int {
        var total: Int = 0
        for budget in budgets {
            total += budget.limit
        }
        
        return total
    }
}

