//
//  ViewController.swift
//  Sessionz
//
//  Created by C4Q on 5/14/18.
//  Copyright © 2018 C4Q. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {
  var userLoginView = LoginView()
    
    lazy var logoImageView: UIImageView = {
        let imageView = UIImageView()
        //todo get custom logo 
        imageView.image = nil
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = Stylesheet.Colors.customPurple
        return imageView
    }()
    
    let forgotPassView = ForgotPassView()
    private var authUserService = AuthUserService.manager
    var verificationTimer: Timer = Timer() //For email verification
    var activeTextField: UITextField = UITextField()

    override func viewDidLoad() {
        super.viewDidLoad()
        loginViewConstraints()
        userLoginView.signUpButton.addTarget(self, action: #selector(signUp), for: .touchUpInside)
        if let emailExist = UserDefaultsHelper.manager.getEmail() {
            userLoginView.emailTextField.text = emailExist
        }
        
            userLoginView.emailTextField.delegate = self
            userLoginView.passwordTextField.delegate = self
        
            
            if Auth.auth().currentUser != nil {
                //Sign in for logged in users by default
                //let homeVC = HomeViewController()
                //present(homeVC, animated: true, completion: nil
                
            
        }
        userLoginView.loginButton.addTarget(self, action: #selector(login), for: .touchUpInside)
        userLoginView.forgotPassButton.addTarget(self, action: #selector(resetPassword1), for: .touchUpInside)
        self.verificationTimer = Timer.scheduledTimer(timeInterval: 200, target: self, selector: #selector(LoginViewController.signUp) , userInfo: nil, repeats: true)
    }
    
    
    @objc private func signUp() {
        let createAccountVC = CreateAccountViewController()
        createAccountVC.modalTransitionStyle = .coverVertical
        createAccountVC.modalPresentationStyle = .pageSheet
        navigationController?.pushViewController(createAccountVC, animated: true)
    }
    
    func loginViewConstraints(){
        
        view.addSubview(logoImageView)
        logoImageView.snp.makeConstraints { (make) in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(10)
            make.width.equalTo(view.snp.width)
            make.height.equalTo(view.snp.height).multipliedBy(0.3)
            make.centerX.equalTo(view)
        }
        
        view.addSubview(userLoginView)
        userLoginView.snp.makeConstraints { (make) in
            make.top.equalTo(logoImageView.snp.bottom)
            make.width.equalTo(view.snp.width)
            make.bottom.equalTo(view.snp.bottom)
            make.centerX.equalTo(view.snp.centerX)
        }
    }
    
    public func alertForErrors(with message: String) {
        let ac = UIAlertController(title: "Problem Logging In", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        ac.addAction(okAction)
        self.present(ac, animated: true, completion: nil)
    }
    
    
    func customErrorMessage(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    
    
    @objc func login() {
        guard let email = userLoginView.emailTextField.text else {self.alertForErrors(with: "Please enter an email."); return}
        guard !email.isEmpty else {self.alertForErrors(with: "Please enter an email"); return}
        guard let password = userLoginView.passwordTextField.text else {self.alertForErrors(with: "Please enter a password"); return}
        guard !password.isEmpty else {self.alertForErrors(with: "Please enter a password"); return}
        authUserService.delegate = self
        authUserService.login(withEmail: email, password: password)
        
    }
    
    @objc private func resetPassword1() {
        forgotPassView.isHidden = false
        self.navigationController?.isNavigationBarHidden = true
        forgotPassViewConstraints()
        forgotPassView.resetPasswordButton.addTarget(self, action: #selector(resetPassword1), for: .touchUpInside)
        forgotPassView.dismissButton.addTarget(self, action: #selector(disMissSelfButton), for: .touchUpInside)
        
    }
    
    @objc private func resetPassword() {
        guard let email = forgotPassView.emailTextField.text else { print("Invalid email"); return}
        guard !email.isEmpty else { print("Enter email please"); return}
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            if error == nil {
                //Present Alert
                let ac = UIAlertController(title: "Email Sent", message: "An email with reset instructions has been sent.", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "Ok", style: .default, handler: {_ in self.dimissSelf() })
                ac.addAction(okAction)
                print("Password reset email sent")
                self.present(ac, animated: true)
            }
            else {
                if let errorCode = AuthErrorCode(rawValue: error!._code) {
                    var message = ""
                    switch errorCode{
                    case .missingEmail:
                        message = "Please enter an email."
                    case .invalidEmail:
                        message = "Please enter a valid email."
                    case .userNotFound:
                        message = "There is no record of an account with this email. Please check that your email is correct."
                    default:
                        break
                    }
                    let ac = UIAlertController(title: "Problem Resetting Password", message: message, preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                    ac.addAction(okAction)
                    self.present(ac, animated: true, completion: nil)
                }
                print("Error in trying to reset passsword: \(String(describing: error?.localizedDescription))")
            }
        }
    }
    
    @objc func disMissSelfButton() {
        forgotPassView.isHidden = true
        //self.navigationController?.isNavigationBarHidden = false
        //self.forgotPassView.dismiss(animated: true, completion: nil)
    }
    
    func dimissSelf() {
        forgotPassView.isHidden = true
        //       self.navigationController?.isNavigationBarHidden = false
        //self.forgotPassView.dismiss(animated: true, completion: nil)
    }
    
    
    
    func forgotPassViewConstraints(){
        //signUpView.isHidden = true
        view.addSubview(forgotPassView)
        forgotPassView.snp.makeConstraints { (make) in
            make.top.equalTo(logoImageView.snp.bottom)
            make.leading.trailing.equalTo(self.view).inset(30)
            make.bottom.equalTo(view.snp.bottom).offset(-30)
            make.centerX.equalTo(view.snp.centerX)
        }
        
    }
    

}
extension LoginViewController: AuthUserDelegate {
    func didFailCreatingUser(_ userService: AuthUserService, error: Error) {
        customErrorMessage(title: "Create user failed", message: error.localizedDescription)
    }
    
    func didCreateUser(_ userService: AuthUserService, user: User) {
        
    }
    
    func didFailSigningOut(_ userService: AuthUserService, error: Error) {
        
    }
    
    func didSignOut(_ userService: AuthUserService) {
        let loginVC = LoginViewController()
        self.dismiss(animated: true, completion: nil)
        present(loginVC, animated: true, completion: nil)
    }
    
    func didFailToSignIn(_ userService: AuthUserService, error: Error) {
         customErrorMessage(title: "SignIn failed", message: error.localizedDescription)
    }
    
    func didSignIn(_ userService: AuthUserService, user: User) {
         userLoginView.passwordTextField.text = nil
        let homeVC = HomeViewController()
        let navController = UINavigationController(rootViewController: homeVC)
        present(navController, animated: true, completion: nil)
        
    }
    
    func didFailToSendPasswordReset(_ userService: AuthUserService, error: Error) {
        
    }
    
    func didSendPasswordReset(_userService: AuthUserService) {
        
    }
    
    func didAddInfoToUser(_ userService: AuthUserService, user: User) {
        
    }
    
    func didFailToAddInfoToUser(_ userService: AuthUserService, error: Error) {
        
    }
    
    
}
extension LoginViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.activeTextField = textField
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

