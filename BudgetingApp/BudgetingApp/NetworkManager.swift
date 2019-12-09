//
//  NetworkManager.swift
//  BudgetingApp
//
//  Created by Janice Jung on 12/7/19.
//  Copyright © 2019 Janice Jung. All rights reserved.
//

import Foundation
import Alamofire

class NetworkManager {
    
    private static let endpointRoot = "http://35.190.148.42"
    
    
    //HANDLING USERS
    
    static func registerUser(email: String, password: String, first: String, last: String, completion: @escaping () -> Void) {
        let parameters: [String: String] = [
            "email": email,
            "password": password,
            "first_name": first,
            "last_name": last
        ]
        
        let endpoint = endpointRoot + "/register/"
        
        Alamofire.request(endpoint, method: .post, parameters: parameters, encoding: JSONEncoding.default).validate().responseData { response in
                switch response.result {
                case .success(let _):
                    print("success")
                    completion()
                case .failure(let error):
                    print(error.localizedDescription)
            }
        
        }
    }
    
    static func login(email: String, password: String, completion: @escaping () -> Void) {
        let endpoint = endpointRoot + "/login/"
        
        let parameters: [String: Any] = [
            "email": email,
            "password": password
        ]
        
        Alamofire.request(endpoint, method: .post, parameters: parameters, encoding: JSONEncoding.default).validate().responseData { response in
                switch response.result {
                case .success(let _):
                    print("success in logging in")
                    completion()
                case .failure(let error):
                    print("failed to log in")
                    print(error.localizedDescription)
            }
        
        }
        
    }
    
    static func deleteUser(userID: Int, completion: @escaping () -> Void){
        let userIDString = String(userID)
        
        let endpoint = endpointRoot + "/api/user/" + userIDString + "/"
        
        Alamofire.request(endpoint, method: .delete).validate().responseData { response in
                switch response.result {
                case .success(let _):
                    print("success in deleting user")
                    completion()
                case .failure(let error):
                    print(error.localizedDescription)
            }
        }
    }
    
    static func getUsers(completion: @escaping ([User]) -> Void) {
        
        let endpoint = endpointRoot + "/api/users/"
        
        Alamofire.request(endpoint, method: .get).validate().responseData { response in
            switch response.result {
            case .success(let data1):
                let jsonDecoder = JSONDecoder()
                
                if let usersData = try? jsonDecoder.decode(getUserResponse.self, from: data1) {
                    let users = usersData.data
                    completion(users)
                }
                print("failed to decode")
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    static func getUserIDByEmail(email: String, completion: @escaping (User) -> Void) {
        let endpoint = endpointRoot + "/api/user/" + email + "/"
        
        Alamofire.request(endpoint, method: .get).validate().responseData { response in
            switch response.result {
            case .success(let data):
                let jsonDecoder = JSONDecoder()
                
                if let userData = try? jsonDecoder.decode(getSingleUserResponse.self, from: data) {
                    let user = userData
                    completion(user.data)
                }
                print("failed to decode")
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    
//HANDLING EXPENSES
    
    static func getExpensesForUser(userID: Int, completion: @escaping ([Expense]) -> Void) {
        let userIDString = String(userID)
        let endpoint = endpointRoot + "/api/expenses/" + userIDString + "/"
        
        Alamofire.request(endpoint, method: .get).validate().responseData { response in
            switch response.result {
            case .success(let data):
                let jsonDecoder = JSONDecoder()
                
                if let expensesData = try? jsonDecoder.decode(getExpensesResponse.self, from: data) {
                    let expenses = expensesData.data
                    completion(expenses)
                }
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    static func getExpensesForCategory(userID: Int, tagID: Int, completion: @escaping ([Expense]) -> Void) {
        
        let userIDString = String(userID)
        let tagIDString = String(tagID)
        let endpoint = endpointRoot + "/api/expenses/" + userIDString + "/" + tagIDString + "/"
        
        Alamofire.request(endpoint, method: .get).validate().responseData { response in
            switch response.result {
            case .success(let data):
                let jsonDecoder = JSONDecoder()
                
                if let expensesData = try? jsonDecoder.decode(getExpensesResponse.self, from: data) {
                    let expenses = expensesData.data
                    completion(expenses)
                }
                print("failed to decode")
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
    }
    
    static func createExpense(userID: Int, tagID: Int, title: String, amount: String, description: String, date: String, completion: @escaping (Expense) -> Void) {
        let userIDString = String(userID)
        let tagIDString = String(tagID)
        
        let endpoint = endpointRoot + "/api/expense/" + userIDString + "/" + tagIDString + "/"

        let amountFloat = Float(amount)
        
        let parameters: [String: Any] = [
            "title": title,
            "amount": amountFloat,
            "description": description,
            "date": date
        ]
        
        Alamofire.request(endpoint, method: .post, parameters: parameters, encoding: JSONEncoding.default).validate().responseData { response in
                switch response.result {
                case .success(let data):
                    let jsonDecoder = JSONDecoder()
                    print("success in creating expense")
                    if let expense = try? jsonDecoder.decode(createExpensesResponse.self, from: data) {
                        completion(expense.data)
                    }
                case .failure(let error):
                    print(error.localizedDescription)
            }
        
        }
        
    }
    
    static func editExpense(expenseID: Int, title: String, amount: String, description: String, date: String, tag: Int, completion: @escaping (Expense) -> Void) {
            let expenseIDString = String(expenseID)
            
            let endpoint = endpointRoot + "/api/expense/edit/" + expenseIDString + "/"
            
            let amountFloat = Float(amount)
            
            let parameters: [String: Any] = [
                "title": title,
                "amount": amountFloat,
                "description": description,
                "date": date,
                "tag": tag
            ]
            
            Alamofire.request(endpoint, method: .post, parameters: parameters, encoding: JSONEncoding.default).validate().responseData { response in
                    switch response.result {
                    case .success(let data):
                        let jsonDecoder = JSONDecoder()
                        print("success in editing expense")
                        if let expense = try? jsonDecoder.decode(createExpensesResponse.self, from: data) {
                            completion(expense.data)
                        }
                    case .failure(let error):
                        print(error.localizedDescription)
                }
            
            }
            
        }
    
    
    static func deleteExpense(expenseID: Int, completion: @escaping () -> Void) {
        let expenseIDString = String(expenseID)
        
        let endpoint = endpointRoot + "/api/expense/" + expenseIDString + "/"
        
        Alamofire.request(endpoint, method: .delete).validate().responseData { response in
                switch response.result {
                case .success(let _):
                    print("success in deleting expense")
                    completion()
                case .failure(let error):
                    print(error.localizedDescription)
            }
        }
    }
    

    //HANDLING BUDGETS
    
    static func getBudgets(userID: Int, completion: @escaping ([Budget]) -> Void) {
        let userIDString = String(userID)
        let endpoint = endpointRoot + "/api/budgets/" + userIDString + "/"
        
        Alamofire.request(endpoint, method: .get).validate().responseData { response in
            switch response.result {
            case .success(let data):
                let jsonDecoder = JSONDecoder()
                
                if let budgetsData = try? jsonDecoder.decode(getBudgetsResponse.self, from: data) {
                    let budgets = budgetsData.data
                    completion(budgets)
                }
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    static func getBudgetByCategory(userID: Int, tagID: Int, completion: @escaping (Budget) -> Void) {
        let userIDString = String(userID)
        let tagIDString = String(tagID)
        
        let endpoint = endpointRoot + "/api/budget/" + userIDString + "/" + tagIDString + "/"
        
        Alamofire.request(endpoint, method: .get).validate().responseData { response in
            switch response.result {
            case .success(let data):
                let jsonDecoder = JSONDecoder()
                
                if let budgetData = try? jsonDecoder.decode(Budget.self, from: data) {
                    let budget = budgetData
                    completion(budget)
                }
                print("failed to decode")
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    static func createBudget(userID: Int, tagID: Int, limit: String, completion: @escaping (Budget) -> Void) {
            let userIDString = String(userID)
            let tagIDString = String(tagID)
                
            let endpoint = endpointRoot + "/api/budget/" + userIDString + "/" + tagIDString + "/"
                
            let limitInt = Int(limit)
                
            let parameters: [String: Any] = [
                "limit": limitInt
            ]
                
            Alamofire.request(endpoint, method: .post, parameters: parameters, encoding: JSONEncoding.default).validate().responseData { response in
                    switch response.result {
                    case .success(let data):
                        print("success in creating budget")
                        let jsonDecoder = JSONDecoder()
                        if let budget = try? jsonDecoder.decode(createBudgetsResponse.self, from: data) {
                            completion(budget.data)
                        }
                    
                    case .failure(let error):
                        print("failed to create budget")
                        print(error.localizedDescription)
                }
                
            }
    }
    
    static func editBudget(budgetID: Int, limit: String, tagID: Int, completion: @escaping () -> Void) {
        let limitInt = Int(limit)
        let parameters: [String: Any] = [
            "limit": limitInt,
            "tag_id": tagID
        ]
        
        let budgetIDString = String(budgetID)
        
        let endpoint = endpointRoot + "/api/budget/edit/" + budgetIDString + "/"
        
        Alamofire.request(endpoint, method: .post, parameters: parameters, encoding: JSONEncoding.default).validate().responseData { response in
                switch response.result {
                case .success(let _):
                    print("success in editing budget")
                    completion()
                case .failure(let error):
                    print(error.localizedDescription)
            }
        
        }
        
    }
    
    
    static func deleteBudget(budgetID: Int, completion: @escaping () -> Void) {
        let budgetIDString = String(budgetID)
        
        let endpoint = endpointRoot + "/api/budget/" + budgetIDString + "/"
        
        Alamofire.request(endpoint, method: .delete).validate().responseData { response in
                switch response.result {
                case .success(let _):
                    print("success in deleting budget")
                    completion()
                case .failure(let error):
                    print(error.localizedDescription)
            }
        }
    }

}
