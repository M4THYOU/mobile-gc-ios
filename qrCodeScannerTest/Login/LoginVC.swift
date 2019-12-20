//
//  LoginVC.swift
//  qrCodeScannerTest
//
//  Created by Matthew Wolfe on 2019-12-16.
//  Copyright © 2019 Matthew Wolfe. All rights reserved.
//

import UIKit

class LoginVC: UIViewController {
    
    let logoImageView: UIImageView = {
        let image = #imageLiteral(resourceName: "logo")
        
        let iv = UIImageView()
        iv.image = image
        return iv
        
    }()
    
    let emailField: LeftPaddedTextField = {
        let tf = LeftPaddedTextField()
        
        tf.placeholder = "Enter your email"
        tf.layer.borderColor = UIColor.gray.cgColor
        tf.layer.borderWidth = 1
        tf.textColor = .black
        
        tf.keyboardType = .emailAddress
        tf.returnKeyType = .next
        
        tf.autocorrectionType = .no
        tf.autocapitalizationType = .none
        tf.spellCheckingType = .no
        
        return tf
    }()
    
    let passwordField: LeftPaddedTextField = {
        let tf = LeftPaddedTextField()
        
        tf.placeholder = "Enter your password"
        tf.layer.borderColor = UIColor.gray.cgColor
        tf.layer.borderWidth = 1
        tf.textColor = .black
        
        tf.isSecureTextEntry = true
        tf.returnKeyType = .done
        
        tf.autocorrectionType = .no
        tf.autocapitalizationType = .none
        tf.spellCheckingType = .no
        
        return tf
    }()
    
    let emailLabel: UILabel = {
        let label = UILabel()
        
        label.text = "Email Address"
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 16)
        
        return label
    }()
    
    let passwordLabel: UILabel = {
        let label = UILabel()
        
        label.text = "Password"
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 16)
        
        return label
    }()
    
    let emailErrorLabel: ErrorLabel = {
        let frame = CGRect(x: 0, y: 0, width: 100, height: 50)
        let label = ErrorLabel(frame: frame)
        
        //label.text = "This is some test error text for emailErrorLabel."
        
        return label
    }()
    
    let passwordErrorLabel: ErrorLabel = {
        let frame = CGRect(x: 0, y: 0, width: 100, height: 50)
        let label = ErrorLabel(frame: frame)
        
        //label.text = "This is some test error text for passwordErrorLabel."
        
        return label
    }()
    
    let loginButton: UIButton = {
        let button = UIButton()
        
        button.setTitle("Login", for: .normal)
        button.backgroundColor = Colors.quakedDarkBlue
        button.setTitleColor(.white, for: .normal)
        
        button.addTarget(self, action: #selector(loginHandler), for: .touchUpInside)
        
        return button
    }()
    
    @objc func loginHandler() {
        
        if let emailString = emailField.text, let passwordString = passwordField.text {
            let validEmail = isValidEmail(email: emailString)
            let validPassword = isValidPassword(password: passwordString)
            
            if validEmail && validPassword {
                
                apiLogin(username: emailString, password: passwordString, completion: { (result, error) in
                    
                    if let error = error {
                        print(error)
                        return
                    }
                    
                    // Every result has a "token" field. If token is nil, then it also has an error field, which is a string.
                    guard let result = result as? Dictionary<String, Any> else { return }
                    
                    if let token = result["token"] as? String {
                        setToken(token: token)
                        DispatchQueue.main.async {
                            self.navigationController?.pushViewController(ScannerVC(), animated: true)
                        }
                    } else {
                        let resultError = result["error"] as! String
                        // show the error.
                        DispatchQueue.main.async {
                            self.emailField.layer.borderColor = UIColor.red.cgColor
                            self.passwordField.layer.borderColor = UIColor.red.cgColor
                            self.passwordErrorLabel.text = resultError
                        }
                        
                    }
                    
                })
                
            }
            
        }
        
    }
    
    /****************************************************************************************/
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        setupViews()
        
    }
        
    /****************************************************************************************/
    
    func setupViews() {
        
        view.addSubview(logoImageView)
        view.addSubview(emailField)
        view.addSubview(passwordField)
        view.addSubview(emailLabel)
        view.addSubview(passwordLabel)
        view.addSubview(emailErrorLabel)
        view.addSubview(passwordErrorLabel)
        
        view.addSubview(loginButton)
        
        let screenWidth = UIScreen.main.bounds.width
        
        _ = logoImageView.anchor(top: view.topAnchor, left: nil, bottom: nil, right: nil, topConstant: 40, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 128, heightConstant: 128)
        logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        _ = emailField.anchor(top: logoImageView.bottomAnchor, left: nil, bottom: nil, right: nil, topConstant: 30, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: screenWidth - 80, heightConstant: 50)
        emailField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        _ = passwordField.anchor(top: emailField.bottomAnchor, left: nil, bottom: nil, right: nil, topConstant: 40, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: screenWidth - 80, heightConstant: 50)
        passwordField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        _ = emailLabel.anchor(top: nil, left: emailField.leftAnchor, bottom: emailField.topAnchor, right: nil, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        
        _ = passwordLabel.anchor(top: nil, left: passwordField.leftAnchor, bottom: passwordField.topAnchor, right: nil, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        
        _ = emailErrorLabel.anchor(top: emailField.bottomAnchor, left: emailField.leftAnchor, bottom: nil, right: nil, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        
        _ = passwordErrorLabel.anchor(top: passwordField.bottomAnchor, left: passwordField.leftAnchor, bottom: nil, right: nil, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        
        _ = loginButton.anchor(top: passwordField.bottomAnchor, left: nil, bottom: nil, right: nil, topConstant: 20, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: screenWidth - 80, heightConstant: 50)
        loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
    }
    
    func isValidEmail(email: String) -> Bool {
        
        let emailRegex = "^[a-zA-Z0-9_+&*-]+(?:\\.[a-zA-Z0-9_+&*-]+)*@(?:[a-zA-Z0-9-]+\\.)+[a-zA-Z]{2,7}$"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegex)
        
        if !emailTest.evaluate(with: email) {
            emailErrorLabel.text = "Invalid Email Address."
            emailField.layer.borderColor = UIColor.red.cgColor
            return false
        }
        
        if email.isEmpty {
            emailErrorLabel.text = "Please enter a value."
            emailField.layer.borderColor = UIColor.red.cgColor
            return false
        }
        
        emailErrorLabel.text = nil
        emailField.layer.borderColor = UIColor.lightGray.cgColor
        return true
        
    }
    
    func isValidPassword(password: String) -> Bool {
        
        if password.count < 5 {
            passwordErrorLabel.text = "Password must be at least 5 characters."
            passwordField.layer.borderColor = UIColor.red.cgColor
            return false
        }
        
        passwordErrorLabel.text = nil
        passwordField.layer.borderColor = UIColor.lightGray.cgColor
        return true
        
    }
    
}
