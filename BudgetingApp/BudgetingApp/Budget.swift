//
//  Budget.swift
//  BudgetingApp
//
//  Created by Janice Jung on 11/20/19.
//  Copyright © 2019 Janice Jung. All rights reserved.
//

//enum Category: String {
//    case Food
//    case Entertainment
//    case Bills
//    case Groceries
//    case Shop
//    case Transport
//    case Other
//}

import Foundation

struct createBudgetsResponse: Codable {
    var success: Bool
    var data: Budget
}

struct getBudgetsResponse: Codable {
    var success: Bool
    var data: [Budget]
}

struct Budget: Codable {
    var budget_id: Int
    var limit: Int
    var tag_id: Int
//    var category: String
//    var amount: String
//
//    init(category: String, amount: String) {
//        self.category = category
//        self.amount = amount
//    }
    
}

//id:
//title:          name of the budget
//limit:          The cap on the amount of money the user wants in spend
//length:         The time frame in which the budget is active, Default: Month [week, month, year]
//user_id:        Links the budget to one user
//tag_id:         Links the budget to a tag
