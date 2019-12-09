//
//  SignUpViewController.swift
//  BudgetingApp
//
//  Created by Janice Jung on 12/7/19.
//  Copyright © 2019 Janice Jung. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {
    
    var titleLabel: UILabel!
    var firstTextField: UITextField!
    var lastTextField: UITextField!
    var emailTextField: UITextField!
    var passwordTextField: UITextField!
    var signUpButton: UIButton!
    var orLogInButton: UIButton!
    
    var users: [User] = []
    
    let padding = CGFloat(10)
    let radius = CGFloat(16)
    let nameWidth = CGFloat(150)
    let height = CGFloat(37)

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .background
        
        getUsers()
        
        titleLabel = UILabel()
        titleLabel.text = "let's get started"
        titleLabel.font = .systemFont(ofSize: 30, weight: .medium)
        titleLabel.textColor = .main
        view.addSubview(titleLabel)
        
        
        firstTextField = UITextField()
        firstTextField.attributedPlaceholder = NSAttributedString(string: "first", attributes: [NSAttributedString.Key.foregroundColor: UIColor.secondary])
        firstTextField.font = .systemFont(ofSize: 15, weight: .medium)
        firstTextField.textColor = .main
        firstTextField.backgroundColor = .background
        firstTextField.layer.borderColor = UIColor.accentGreen.cgColor
        firstTextField.layer.masksToBounds = true
        firstTextField.layer.borderWidth = 1.5
        firstTextField.layer.cornerRadius = radius
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: self.firstTextField.frame.height))
        firstTextField.leftView = paddingView
        firstTextField.leftViewMode = UITextField.ViewMode.always
        view.addSubview(firstTextField)
        
        
        lastTextField = UITextField()
        lastTextField.attributedPlaceholder = NSAttributedString(string: "last", attributes: [NSAttributedString.Key.foregroundColor: UIColor.secondary])
        lastTextField.font = .systemFont(ofSize: 15, weight: .medium)
        lastTextField.textColor = .main
        lastTextField.backgroundColor = .background
        lastTextField.layer.borderColor = UIColor.accentGreen.cgColor
        lastTextField.layer.masksToBounds = true
        lastTextField.layer.borderWidth = 1.5
        lastTextField.layer.cornerRadius = radius
        let paddingView2 = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: self.lastTextField.frame.height))
        lastTextField.leftView = paddingView2
        lastTextField.leftViewMode = UITextField.ViewMode.always
        view.addSubview(lastTextField)
        
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

        signUpButton = UIButton()
        signUpButton.titleLabel?.text = "Sign Up"
        signUpButton.setTitle("Sign Up", for: .normal)
        signUpButton.setBackgroundImage(UIImage(named: "accent"), for: .normal)
        signUpButton.titleLabel?.font = .systemFont(ofSize: 17, weight: .medium)
        signUpButton.titleLabel?.textColor = .white
        signUpButton.layer.cornerRadius = 25
        signUpButton.layer.masksToBounds = true
        signUpButton.addTarget(self, action: #selector(signUp), for: .touchUpInside)
        view.addSubview(signUpButton)
        
        orLogInButton = UIButton()
        orLogInButton.setTitle("or log in!", for: .normal)
        orLogInButton.setBackgroundImage(UIImage(named: "background"), for: .normal)
        orLogInButton.titleLabel?.font = .systemFont(ofSize: 17, weight: .medium)
        orLogInButton.setTitleColor(.secondary, for: .normal)
        orLogInButton.layer.cornerRadius = 25
        orLogInButton.layer.masksToBounds = true
        orLogInButton.addTarget(self, action: #selector(orLogIn), for: .touchUpInside)
        view.addSubview(orLogInButton)
        
        setupConstraints()
        
    }
    
    func setupConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(100)
            make.centerX.equalTo(view)
        }
        
        firstTextField.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(100)
            make.right.equalTo(view.snp.centerX).offset(-(padding/2)+1)
            make.width.equalTo(nameWidth)
            make.height.equalTo(height)
        }
        
        lastTextField.snp.makeConstraints { make in
            make.top.width.height.equalTo(firstTextField)
            make.left.equalTo(view.snp.centerX).offset(padding/2 - 1)
        }
        
        emailTextField.snp.makeConstraints { make in
            make.top.equalTo(firstTextField.snp.bottom).offset(padding)
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
        
        signUpButton.snp.makeConstraints { make in
            make.top.equalTo(passwordTextField.snp.bottom).offset(130)
            make.width.equalTo(nameWidth * 2 + padding - 2)
            make.height.equalTo(height * 1.4)
            make.centerX.equalTo(view)
        }
        
        orLogInButton.snp.makeConstraints { make in
            make.top.equalTo(signUpButton.snp.bottom).offset(30)
            make.width.equalTo(100)
            make.height.equalTo(40)
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
    
    @objc func signUp() {
        if let first = firstTextField.text, let last = lastTextField.text, let email = emailTextField.text, let password = passwordTextField.text {
            NetworkManager.registerUser(email: email, password: password, first: first, last: last) {
                print("register user")
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
    
    @objc func orLogIn() {
        let viewController = LogInViewController()
        navigationController?.pushViewController(viewController, animated: true)
    }
    
}
