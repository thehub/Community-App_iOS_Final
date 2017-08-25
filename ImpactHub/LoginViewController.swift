//
//  LoginViewController.swift
//  LightfulAdmin
//
//  Created by Niklas on 01/03/2017.
//  Copyright © 2017 Lightful Ltd. All rights reserved.
//

import UIKit
import Auth0
import SalesforceSDKCore

class LoginViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    @IBOutlet weak var logoTopConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var loginBgView: UIView!
    @IBOutlet weak var emailBgView: UIView!
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

    var didLayout = false
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if didLayout {
            return
        }
        didLayout = true
        addShadow()
    }
    
    func addShadow() {
        loginBgView.layer.shadowColor = UIColor(hexString: "F52929").cgColor
        loginBgView.layer.shadowOffset = CGSize(width: 0, height: 5)
        loginBgView.layer.shadowOpacity = 0.97
        loginBgView.layer.shadowPath = UIBezierPath(rect: loginBgView.layer.bounds).cgPath
        loginBgView.layer.shadowRadius = 8
        loginBgView.layer.shouldRasterize = true
        loginBgView.layer.rasterizationScale = UIScreen.main.scale

        emailBgView.layer.shadowColor = UIColor(hexString: "F52929").cgColor
        emailBgView.layer.shadowOffset = CGSize(width: 0, height: 5)
        emailBgView.layer.shadowOpacity = 0.97
        emailBgView.layer.shadowPath = UIBezierPath(rect: emailBgView.layer.bounds).cgPath
        emailBgView.layer.shadowRadius = 8
        emailBgView.layer.shouldRasterize = true
        emailBgView.layer.rasterizationScale = UIScreen.main.scale
    }

    
    var topConstraintDefault: CGFloat = 0
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        registerForKeyboardNotifications()
        self.topConstraintDefault = self.topConstraint.constant
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let observer = self.observer1 {
            NotificationCenter.default.removeObserver(observer)
        }
        if let observer = self.observer2 {
            NotificationCenter.default.removeObserver(observer)
        }
    }
    
    var observer1: NSObjectProtocol?
    var observer2: NSObjectProtocol?

    
    func registerForKeyboardNotifications() {
        //Adding notifies on keyboard appearing
        self.observer1 = NotificationCenter.default.addObserver(forName: NSNotification.Name.UIKeyboardWillShow, object: nil, queue: OperationQueue.main) { (note) in
            self.keyboardWasShown(notification: note)
        }
        
        self.observer2 = NotificationCenter.default.addObserver(forName: NSNotification.Name.UIKeyboardWillHide, object: nil, queue: OperationQueue.main) { (note) in
            self.keyboardWillBeHidden(notification: note)
        }
    }
    
    func deregisterFromKeyboardNotifications() {
        if let observer = self.observer1 {
            NotificationCenter.default.removeObserver(observer)
        }
        if let observer = self.observer2 {
            NotificationCenter.default.removeObserver(observer)
        }
    }
    
    func keyboardWasShown(notification: Notification) {
        var info : Dictionary = notification.userInfo!
        if let keyboardSize = (info[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.size {
            self.topConstraint.constant = topConstraintDefault - 58 //-keyboardSize.height/5
            UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                self.view.layoutIfNeeded()
                self.logo.transform = CGAffineTransform.init(scaleX: 0.7, y: 0.7)
            }) { (_) in
            }
        }
    }
    
    func keyboardWillBeHidden(notification: Notification?) {
        self.topConstraint.constant = topConstraintDefault
        UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
            self.view.layoutIfNeeded()
            self.logo.transform = CGAffineTransform.identity
        }) { (_) in
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.modalPresentationCapturesStatusBarAppearance = true
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

    
    
    
    @IBAction func linkedInTap(_ sender: Any) {
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
                                    NotificationCenter.default.post(name: .onLogin, object: nil, userInfo: nil)
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

//        textField.textColor = UIColor.white
        
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
//        passwordTextField.textColor = UIColor.white
        if passwordTextField.text!.characters.count < 7 {
            passwordTextField.layer.add(Animations.shakeAnimation, forKey: "shakeIt")
            isValid = false
            passwordTextField.becomeFirstResponder()
        }
        return isValid
    }
    
    func checkEmail() -> Bool {
        var isValid = true
//        emailTextField.textColor = UIColor.white
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

    /**
     Dismiss keyboard when tapped outside the keyboard or textView
     
     :param: touches the touches
     :param: event   the related event
     */
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            if touch.phase == UITouchPhase.began {
                passwordTextField?.resignFirstResponder()
                emailTextField.resignFirstResponder()
            }
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    
}
