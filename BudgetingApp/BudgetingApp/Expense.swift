//
//  Expense.swift
//  BudgetingApp
//
//  Created by Janice Jung on 11/21/19.
//  Copyright © 2019 Janice Jung. All rights reserved.
//

import Foundation

struct Expense: Codable {
//    var id: String
//    var title: String
//    var amount: String
//    var description: String
//    var date: String
//    var user_id: String
//    var tags: String
    var category: String
    var amount: String
    var note: String
    
    init(category: String, amount: String, note: String) {
        self.category = category
        self.amount = amount
        self.note = note
    }
    
}

//id:             Gives additional detail to access a specific expense recorded
//title:          Name of the expense logged
//amount:         The cost of the expense (Currency: USD?)
//description:    (Optional) Details about the expense logged (i.e. where/why was the purchase made?)
//date:           Date of when the purchase was made, for organization and display
//user_id:        Links the expenses to one user
//tags:           List of related tags to the expense
