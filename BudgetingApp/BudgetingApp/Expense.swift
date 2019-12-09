//
//  Expense.swift
//  BudgetingApp
//
//  Created by Janice Jung on 11/21/19.
//  Copyright © 2019 Janice Jung. All rights reserved.
//

import Foundation

struct createExpensesResponse: Codable {
    var success: Bool
    var data: Expense
}

struct getExpensesResponse: Codable {
    var success: Bool
    var data: [Expense]
}

class Expense: Codable {
    var expense_id: Int
    var title: String
    var amount: Float
    var description: String
    var date: String
    var tag: Int

    
//    'expense_id': self.id,
//    'title': self.title,
//    'amount': self.amount,
//    'description': self.description,
//    'date': self.date,
//    'tags': [t.serialize() for t in self.tags]
    
//    init(category: String, amount: String, note: String) {
//        self.category = category
//        self.amount = amount
//        self.note = note
//    }
    
}

//id:             Gives additional detail to access a specific expense recorded
//title:          Name of the expense logged
//amount:         The cost of the expense (Currency: USD?)
//description:    (Optional) Details about the expense logged (i.e. where/why was the purchase made?)
//date:           Date of when the purchase was made, for organization and display
//user_id:        Links the expenses to one user
//tags:           List of related tags to the expense
