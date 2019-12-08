//
//  HomeViewController.swift
//  BudgetingApp
//
//  Created by Janice Jung on 12/6/19.
//  Copyright © 2019 Janice Jung. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    var greetingLabel: UILabel!
    var checkOutLabel: UILabel!
    var bertieImageView: UIImageView!
    var bertieMessageTextView: UITextView!
    var textViewHeight: NSLayoutConstraint!
    
    let textViewPadding = CGFloat(13)
    let imageViewHeight = CGFloat(70)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .background
        
        greetingLabel = UILabel()
        greetingLabel.text = "Hey!"
        greetingLabel.font = .systemFont(ofSize: 32, weight: .semibold)
        greetingLabel.textColor = .main
        view.addSubview(greetingLabel)
        
        
        checkOutLabel = UILabel()
        checkOutLabel.text = "check out where you're @ this month"
        checkOutLabel.font = .systemFont(ofSize: 27, weight: .medium)
        checkOutLabel.textAlignment = .center
        checkOutLabel.lineBreakMode = .byWordWrapping
        checkOutLabel.numberOfLines = 0
        checkOutLabel.textColor = .secondary
        view.addSubview(checkOutLabel)
        
        
        bertieMessageTextView = UITextView()
        bertieMessageTextView.text = "bertie: if i were a police officer i would be pulling u over right now bc ur a speedy spender 😂 seriously though..."
        bertieMessageTextView.textAlignment = .left
        bertieMessageTextView.font = .systemFont(ofSize: 15, weight: .regular)
        bertieMessageTextView.textColor = .main
        bertieMessageTextView.backgroundColor = .bertieGreen
        bertieMessageTextView.layer.cornerRadius = 6
        bertieMessageTextView.textContainerInset = UIEdgeInsets(top: textViewPadding, left: textViewPadding+25, bottom: textViewPadding, right: textViewPadding)
        
        textViewHeight = NSLayoutConstraint()
        textViewHeight.constant = self.bertieMessageTextView.contentSize.height
        bertieMessageTextView.isScrollEnabled = false
        view.addSubview(bertieMessageTextView)
        
        bertieImageView = UIImageView()
        bertieImageView.image = UIImage(named: "bertiezoom")
        bertieImageView.layer.cornerRadius = imageViewHeight / 2
        bertieImageView.layer.masksToBounds = true
        bertieImageView.layer.borderColor = UIColor.background.cgColor
        bertieImageView.layer.borderWidth = 4
        view.addSubview(bertieImageView)
        
        
        setupConstraints()
        
    }
    
    func setupConstraints() {
        greetingLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(60)
            make.centerX.equalTo(view)
        }
        
        checkOutLabel.snp.makeConstraints { make in
            make.top.equalTo(greetingLabel.snp.bottom).offset(20)
            make.width.equalTo(400)
            make.centerX.equalTo(view)
        }
        
        bertieMessageTextView.snp.makeConstraints { make in
            make.top.equalTo(checkOutLabel.snp.bottom).offset(200)
            make.centerX.equalTo(view).offset(15)
            make.width.equalTo(300)
        }
        
        bertieImageView.snp.makeConstraints { make in
            make.centerX.equalTo(bertieMessageTextView.snp.left)
            make.centerY.equalTo(bertieMessageTextView)
            make.width.height.equalTo(imageViewHeight)
            
        }
    }
    
}
