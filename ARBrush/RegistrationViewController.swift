//
//  RegistrationViewController.swift
//  ARBrush
//
//  Created by Andrew Wang on 4/22/23.
//  Copyright © 2023 Laan Labs. All rights reserved.
//

import UIKit

class RegistrationViewController: UIViewController {
    struct Constants {
        static let cornerRadius: CGFloat = 8.0
    }
    private let usernameField: UITextField = {
        let field = UITextField()
        field.placeholder = "Username"
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
    
    private let emailField: UITextField = {
        let field = UITextField()
        field.placeholder = "Email"
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
        return field
    }()
    private let passwordField: UITextField = {
        let field = UITextField()
        field.placeholder = "Create your Password"
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
        field.isSecureTextEntry = true
        return field
    }()
    
    private let confirmPassword: UITextField = {
        let field = UITextField()
        field.placeholder = "Confirm Password"
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
        field.isSecureTextEntry = true
        return field
    }()
    
    private let registerButton: UIButton = {
        let button = UIButton()
        button.setTitle("Sign Up", for: .normal)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = Constants.cornerRadius
        button.backgroundColor = .systemGreen
        button.setTitleColor(.white, for: .normal)
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .secondarySystemBackground
        registerButton.addTarget(self, action: #selector(didTapRegister), for: .touchUpInside)
        usernameField.delegate = self
        passwordField.delegate = self
        view.addSubview(usernameField)
        view.addSubview(emailField)
        view.addSubview(passwordField)
        view.addSubview(confirmPassword)
        view.addSubview(registerButton)
        // Do any additional setup after loading the view.
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        usernameField.frame = CGRect(x: 20, y:view.safeAreaInsets.top+100, width: view.width-40, height:52)
        emailField.frame = CGRect(x: 20, y:usernameField.bottom+10, width: view.width-40, height:52)
        passwordField.frame = CGRect(x: 20, y:emailField.bottom+10, width: view.width-40, height:52)
        confirmPassword.frame = CGRect(x: 20, y:passwordField.bottom+10, width: view.width-40, height:52)
        registerButton.frame = CGRect(x: 20, y:confirmPassword.bottom+10, width: view.width-40, height:52)
    }
    @objc private func didTapRegister(){
        emailField.resignFirstResponder()
        usernameField.resignFirstResponder()
        passwordField.resignFirstResponder()
        confirmPassword.resignFirstResponder()
        
        guard let email = emailField.text, !email.isEmpty, let password = passwordField.text, password.count >= 8, let secondpass = confirmPassword.text, secondpass == password , !password.isEmpty, let username = usernameField.text, !username.isEmpty else{
            return
        }
        AuthManager.shared.registerNewUser(username: username, email: email, password: password){
            registered in
            DispatchQueue.main.async{
                if registered{
                    
                }
                else{
                    
                }
            }
        }
         
    }

}
extension RegistrationViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == usernameField{
            emailField.becomeFirstResponder()
        }
        else if textField == emailField{
            passwordField.becomeFirstResponder()
        }
        else if textField == passwordField{
            confirmPassword.becomeFirstResponder()
        }
        else if textField == confirmPassword{
            didTapRegister()
        }
        return true
    }
}
