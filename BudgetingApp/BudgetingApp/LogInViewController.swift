//
//  LogInViewController.swift
//  BudgetingApp
//
//  Created by Janice Jung on 12/8/19.
//  Copyright © 2019 Janice Jung. All rights reserved.
//

import UIKit

class LogInViewController: UIViewController {

    var titleLabel: UILabel!
    var emailTextField: UITextField!
    var passwordTextField: UITextField!
    var logInButton: UIButton!
    
    var users: [User] = []
    
    let padding = CGFloat(10)
    let radius = CGFloat(16)
    let nameWidth = CGFloat(140)
    let height = CGFloat(37)

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .background
        self.hideKeyboardWhenTappedAround() 
        
        getUsers()
        
        titleLabel = UILabel()
        titleLabel.text = "hey there!"
        titleLabel.font = .systemFont(ofSize: 30, weight: .medium)
        titleLabel.textColor = .main
        view.addSubview(titleLabel)
        
        emailTextField = UITextField()
        emailTextField.attributedPlaceholder = NSAttributedString(string: "email", attributes: [NSAttributedString.Key.foregroundColor: UIColor.secondary])
        emailTextField.font = .systemFont(ofSize: 15, weight: .medium)
        emailTextField.textColor = .main
        emailTextField.backgroundColor = .background
        emailTextField.layer.borderColor = UIColor.accentGreen.cgColor
        emailTextField.layer.masksToBounds = true
        emailTextField.layer.borderWidth = 1.5
        emailTextField.layer.cornerRadius = radius
        let paddingView3 = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: self.emailTextField.frame.height))
        emailTextField.leftView = paddingView3
        emailTextField.leftViewMode = UITextField.ViewMode.always
        view.addSubview(emailTextField)

        passwordTextField = UITextField()
        passwordTextField.attributedPlaceholder = NSAttributedString(string: "password", attributes: [NSAttributedString.Key.foregroundColor: UIColor.secondary])
        passwordTextField.font = .systemFont(ofSize: 15, weight: .medium)
        passwordTextField.textColor = .main
        passwordTextField.backgroundColor = .background
        passwordTextField.layer.borderColor = UIColor.accentGreen.cgColor
        passwordTextField.layer.masksToBounds = true
        passwordTextField.layer.borderWidth = 1.5
        passwordTextField.layer.cornerRadius = radius
        let paddingView4 = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: self.passwordTextField.frame.height))
        passwordTextField.leftView = paddingView4
        passwordTextField.leftViewMode = UITextField.ViewMode.always
        passwordTextField.isSecureTextEntry = true
        view.addSubview(passwordTextField)

        logInButton = UIButton()
        logInButton.setTitle("Log In", for: .normal)
        logInButton.setBackgroundImage(UIImage(named: "accent"), for: .normal)
        logInButton.setTitleColor(.white, for: .normal)
        logInButton.titleLabel?.font = .systemFont(ofSize: 17, weight: .medium)
        logInButton.layer.cornerRadius = 25
        logInButton.layer.masksToBounds = true
        logInButton.addTarget(self, action: #selector(logIn), for: .touchUpInside)
        view.addSubview(logInButton)
        
        setupConstraints()
        
    }
    
    func setupConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(100)
            make.centerX.equalTo(view)
        }
        
        emailTextField.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(100)
            make.centerX.equalTo(view)
            make.width.equalTo(nameWidth * 2 + padding - 2)
            make.height.equalTo(height)
        }
        
        passwordTextField.snp.makeConstraints { make in
            make.top.equalTo(emailTextField.snp.bottom).offset(padding)
            make.centerX.equalTo(view)
            make.width.equalTo(nameWidth * 2 + padding - 2)
            make.height.equalTo(height)
        }
        
        logInButton.snp.makeConstraints { make in
            make.top.equalTo(passwordTextField.snp.bottom).offset(120)
            make.width.equalTo(nameWidth * 2 + padding - 2)
            make.height.equalTo(height * 1.4)
            make.centerX.equalTo(view)
            
        }
    }
    
    func getUsers() {
        NetworkManager.getUsers { users in
            self.users = users
            print(self.users)
            print("Done")
        }
    }
    
    @objc func logIn() {
        if let email = emailTextField.text, let password = passwordTextField.text {
            
            NetworkManager.login(email: email, password: password) {
                print("successfully logged in")
                NetworkManager.getUserIDByEmail(email: email) { user in
                    Statics.user = user
                    print(Statics.user?.email)
                    DispatchQueue.main.async {
                        let viewController = MainTabViewController()
                        self.navigationController?.pushViewController(viewController, animated: true)
                    }
                }
                
            }
            

        }
       
    }
}
