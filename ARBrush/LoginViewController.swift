//
//  LoginViewController.swift
//  ARBrush
//
//  Created by Andrew Wang on 4/22/23.
//  Copyright © 2023 Laan Labs. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    
    
    struct Constants {
        static let cornerRadius: CGFloat = 8.0
    }
    private let usernameEmailField: UITextField = {
        let field = UITextField()
        field.placeholder = "Username or Email"
        field.returnKeyType = .next
        field.leftViewMode = .always
        
        field.leftView = UIView(frame: CGRect(x:0 ,y:0, width: 10, height:0))
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.layer.masksToBounds = true
        field.layer.cornerRadius = Constants.cornerRadius
        field.backgroundColor = .secondarySystemBackground
        field.layer.borderWidth = 1.0
        field.layer.borderColor = UIColor.secondaryLabel.cgColor
        return field
    }()
    
    private let passwordField: UITextField = {
        let field = UITextField()
        field.placeholder = "Password"
        field.returnKeyType = .continue
        field.leftViewMode = .always
        
        field.leftView = UIView(frame: CGRect(x:0 ,y:0, width: 10, height:0))
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.layer.masksToBounds = true
        field.layer.cornerRadius = Constants.cornerRadius
        field.backgroundColor = .secondarySystemBackground
        field.layer.borderWidth = 1.0
        field.layer.borderColor = UIColor.secondaryLabel.cgColor
        field.isSecureTextEntry = true
        return field
    }()
    private let loginButton: UIButton = {
        let button = UIButton()
        button.setTitle("Log In", for: .normal)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = Constants.cornerRadius
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        
        return button
    }()
    
    private let headerView: UIView = {
        let header = UIView()
        header.clipsToBounds = true
        header.backgroundColor = .red //RED PLACEHOLDER TODO: 12:00 at part 3 in video
        return header
    }()
    private let createAccount: UIButton = {
        let button = UIButton()
        button.setTitleColor(.label, for: .normal)
        button.setTitle("Create new account", for: .normal)
        return button
    }()
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        loginButton.addTarget(self, action: #selector(didTapLoginButton), for: .touchUpInside)
        createAccount.addTarget(self, action: #selector(didTapCreateAccount), for: .touchUpInside)

        view.backgroundColor = .systemBackground
        usernameEmailField.delegate = self
        passwordField.delegate = self
        
        addSubviews()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        //assign frames to buttons and ui
        
        headerView.frame = CGRect(x: 0, y: view.safeAreaInsets.top, width: view.width, height: view.height/3.0 )
        usernameEmailField.frame = CGRect(x: 25, y: headerView.bottom + 10, width: view.width-50, height: 52.0 )
        passwordField.frame = CGRect(x: 25, y: usernameEmailField.bottom + 10, width: view.width-50, height: 52.0 )
        loginButton.frame = CGRect(x: 25, y: passwordField.bottom + 10, width: view.width-50, height: 52.0 )
        createAccount.frame = CGRect(x: 25, y: loginButton.bottom + 10, width: view.width-50, height: 52.0 )
        
        
    }
    private func addSubviews() {
        view.addSubview(usernameEmailField)
        view.addSubview(passwordField)
        view.addSubview(loginButton)
        view.addSubview(headerView)
        view.addSubview(createAccount)
    }
    
    @objc private func didTapLoginButton(){
        passwordField.resignFirstResponder()
        usernameEmailField.resignFirstResponder()
        guard let usernameEmail = usernameEmailField.text, !usernameEmail.isEmpty,
              let password = passwordField.text, !password.isEmpty, password.count>=8 else{
            return
        }
        var username: String?
        var email: String?
        if usernameEmail.contains("@"), usernameEmail.contains("."){
            //email
            email = usernameEmail
        }
        else{
            //username
            username = usernameEmail
        }
        
        AuthManager.shared.loginUser(username: username, email: email, password: password) {
            success in
            DispatchQueue.main.async{
                if success {
                    
                    self.dismiss(animated: true, completion: nil)
                }
                else
                {
                    //error occured
                    let alert = UIAlertController(title: "Log in error!!!!", message:"You were unable to log in", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
                    self.present(alert, animated:true)
                }
            }
            
        }
    }
    @objc private func didTapCreateAccount(){
        let vc = RegistrationViewController()
        vc.title = "Create Account"
        present(vc, animated: true)
    }
    //26:40 for terms and services buttons
    
    
    
    
}

extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == usernameEmailField{
            passwordField.becomeFirstResponder()
            
        }
        else if textField == passwordField{
            didTapLoginButton()
        }
        return true
    }
}
