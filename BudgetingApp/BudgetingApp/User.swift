//
//  User.swift
//  BudgetingApp
//
//  Created by Janice Jung on 11/20/19.
//  Copyright © 2019 Janice Jung. All rights reserved.
//

import Foundation

struct getSingleUserResponse: Codable {
    var success: Bool
    var data: User
}

struct getUserResponse: Codable {
    var success: Bool
    var data: [User]
}

struct User: Codable {
    var user_id: Int
    var firstName: String
    var lastName: String
    var email: String
    var expenses: [Expense]
    var budgets: [Budget]
}

//firstName:          First name of the user
//lastName:           Last name of the user
//email:              Valid email of the user
//password_digest:    Password for the user's account
//expenses:           Contains a list of all the user's expenses
//budgets:            Contains a list of all the user's budget goals
