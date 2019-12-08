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
    
    static func getUsers(completion: @escaping ([User]) -> Void) {
        
        let endpoint = endpointRoot + "/api/users/"
        
        Alamofire.request(endpoint, method: .get).validate().responseData { response in
            switch response.result {
            case .success(let data):
                let jsonDecoder = JSONDecoder()
                
                if let usersData = try? jsonDecoder.decode(getUserResponse.self, from: data) {
                    let users = usersData.data
                    completion(users)
                }
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
        
    static func deleteUser(){
            
        
    
    }


}
