//
//  LoginViewController.swift
//  LightfulAdmin
//
//  Created by Niklas on 01/03/2017.
//  Copyright © 2017 Lightful Ltd. All rights reserved.
//

import UIKit
import Auth0

class LoginViewController: UIViewController, UITextFieldDelegate {

    var sessionManager: SessionManager!
    
    @IBOutlet weak var logo: UIImageView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var loginButton: Button!
    @IBOutlet weak var passwordTextField: UITextField!
    
    init(sessionManager: SessionManager = .shared) {
        self.sessionManager = sessionManager
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.sessionManager = .shared
        super.init(coder: aDecoder)
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.modalPresentationCapturesStatusBarAppearance = true

        self.showKeyboard()
    
    }
    
    func showKeyboard() {
        self.emailTextField.becomeFirstResponder()
    }

    @IBAction func clearEmail(_ sender: Any) {
        self.emailTextField.text = nil
    }
    
    
    
    @IBAction func clearPassword(_ sender: Any) {
        self.passwordTextField.text = nil
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func loginPressed(_ sender: Any) {
        if validate() {
            self.emailTextField.resignFirstResponder()
            self.passwordTextField.resignFirstResponder()
            self.view.endEditing(true)
            self.login(email: self.emailTextField.text!, password: self.passwordTextField.text!)
        }
    }

    
    
    
    
    
    
    func login(email: String, password: String) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        view.isUserInteractionEnabled = false

//        scope: "openid profile offline_access"

        
        Auth0
            .authentication()
            .login(
                usernameOrEmail: email,
                password: password,
                realm: "Username-Password-Authentication"
                ,
                scope: "openid profile offline_access"
            )
            .start { result in
                DispatchQueue.main.async {
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                    self.view.isUserInteractionEnabled = true
                }
                switch result {
                case .success(let credentials):
                    // Logged in successfully
//                    guard let accessToken = credentials.accessToken, let idToken = credentials.idToken else { return }
                    guard let accessToken = credentials.accessToken, let idToken = credentials.idToken, let refreshToken = credentials.refreshToken else { return }
                    SessionManager.shared.storeTokens(accessToken, idToken: idToken, refreshToken: refreshToken)
                    debugPrint(credentials.expiresIn)
                    debugPrint(credentials.tokenType)
                    
//                    self.sessionManager.storeTokens(accessToken, idToken: idToken, refreshToken: credentials.refreshToken)
//                    sessionManager.shared.storeTokens(idToken, refreshToken: credentials.refreshToken)
                    self.sessionManager.retrieveProfile { error in
                        DispatchQueue.main.async {
                            if let error = error {
                                print(error.localizedDescription)
                                DispatchQueue.main.async {
                                    self.alertMessage()
                                }
                            }
                            else {
                                self.presentingViewController?.dismiss(animated: true, completion: { 
                                    
                                })
                            }
                        }
                    }
                case .failure(let error):
                    debugPrint(error)
                    DispatchQueue.main.async {
                        self.alertMessage(message: error.localizedDescription)
                    }
                }
        }

    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == self.emailTextField {
            textField.resignFirstResponder()
            _ = checkEmail()
            self.passwordTextField.becomeFirstResponder()
        }
        else if textField == self.passwordTextField {
            self.loginPressed(self.loginButton)
        }

        return false
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }

        textField.textColor = UIColor.white
        
        let newLength = text.utf16.count + string.utf16.count - range.length
        return newLength <= 150
        
    }
    
    func validate() -> Bool {
        let isValidEmail = checkEmail()
        if !isValidEmail {
            return false
        }
        let isValidPassword = checkPassword()
        
        if isValidEmail && isValidPassword {
            return true
        }
        else {
            return false
        }
    }
    
    func checkPassword() -> Bool {
        var isValid = true
        passwordTextField.textColor = UIColor.white
        if passwordTextField.text!.characters.count < 7 {
            passwordTextField.layer.add(Animations.shakeAnimation, forKey: "shakeIt")
            isValid = false
            passwordTextField.becomeFirstResponder()
        }
        return isValid
    }
    
    func checkEmail() -> Bool {
        var isValid = true
        emailTextField.textColor = UIColor.white
        if !isValidEmail(testStr: emailTextField.text!) {
            emailTextField.layer.add(Animations.shakeAnimation, forKey: "shakeIt")
            isValid = false
            emailTextField.becomeFirstResponder()
        }
        return isValid
    }
    
    func isValidEmail(testStr:String) -> Bool {
        
        let regex = try! NSRegularExpression(pattern: "^[A-Z0-9._%+-]+@[A-Z0-9.-]+\\.[A-Z]{2,4}$",
                                             options: [.caseInsensitive])
        
        return regex.firstMatch(in: testStr, options:[],
                                range: NSMakeRange(0, testStr.utf16.count)) != nil
        
        
    }
    
    fileprivate func alertMessage(message: String = "Could not login. Please try again.", title: String = "Error") {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (alertAction) in
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

}
