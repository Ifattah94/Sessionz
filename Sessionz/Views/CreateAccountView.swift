//
//  CreateAccountView.swift
//  Sessionz
//
//  Created by C4Q on 5/21/18.
//  Copyright © 2018 C4Q. All rights reserved.
//

import UIKit

class CreateAccountView: UIView {

    lazy var usernameTextField: UITextField = {
        let userTF = UITextField()
        Stylesheet.Objects.Textfields.UserName.style(textfield: userTF)
        return userTF
    }()
    
    lazy var emailTextField: UITextField = {
        let emailTF = UITextField()
        Stylesheet.Objects.Textfields.LoginEmail.style(textfield: emailTF)
        return emailTF
    }()
    
    lazy var passwordTextField: UITextField  = {
        let passTF = UITextField()
        Stylesheet.Objects.Textfields.LoginPassword.style(textfield: passTF)
        return passTF
    }()
    
    lazy var createButton: UIButton = {
        let button = UIButton()
        button.setTitle("Next", for: .normal)
        Stylesheet.Objects.Buttons.CreateButton.style(button: button)
        return button
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: UIScreen.main.bounds)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        backgroundColor = Stylesheet.Colors.customPurple
        setupViews()
        setUpConstraints()
    }
    
    override func setNeedsLayout() {
        super.setNeedsLayout()
        usernameTextField.setNeedsLayout()
    }
    
    
    private func setupViews() {
        let views = [usernameTextField, emailTextField, passwordTextField, createButton] as [UIView]
        views.forEach { ($0).translatesAutoresizingMaskIntoConstraints = false; addSubview($0)}
        
    }
    
    private func setUpConstraints() {
        usernameTextField.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(80)
            make.width.equalTo(self.snp.width).multipliedBy(0.9)
            make.height.equalTo(self.snp.height).multipliedBy(0.1)
            make.centerX.equalTo(self.snp.centerX)
        }
        
        
        // setUp EmailTF
        emailTextField.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(usernameTextField.snp.bottom).offset(20)
            make.width.equalTo(self).multipliedBy(0.9)
            make.height.equalTo(self).multipliedBy(0.1)
            make.centerX.equalTo(self)
            
        }
        
        //setUp Password
        passwordTextField.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(emailTextField.snp.bottom).offset(20)
            make.width.equalTo(self).multipliedBy(0.9)
            make.height.equalTo(self).multipliedBy(0.1)
            make.centerX.equalTo(self)
        }
        
        //setUp Createaccount button
        createButton.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(self).multipliedBy(0.3)
            make.height.equalTo(self).multipliedBy(0.1)
            make.top.equalTo(passwordTextField.snp.bottom).offset(20)
            make.centerX.equalTo(self)
            
            createButton.layer.cornerRadius = 15
            createButton.layer.masksToBounds = true
        }
    }

}
