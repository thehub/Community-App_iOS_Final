//
//  ResetPasswordViewController.swift
//  LightfulAdmin
//
//  Created by Niklas on 01/03/2017.
//  Copyright © 2017 Lightful Ltd. All rights reserved.
//

import UIKit
import Auth0

class ResetPasswordViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var pleaseText: UILabel!
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    @IBOutlet weak var logo: UIImageView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var sendButton: WhiteButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.modalPresentationCapturesStatusBarAppearance = true

        // Do any additional setup after loading the view.
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
            self.topConstraint.constant = topConstraintDefault - 68 //-keyboardSize.height/5
            UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                self.view.layoutIfNeeded()
                self.logo.transform = CGAffineTransform.init(scaleX: 0.7, y: 0.7)
                self.pleaseText.alpha = 0
            }) { (_) in
            }
        }
    }
    
    func keyboardWillBeHidden(notification: Notification?) {
        self.topConstraint.constant = topConstraintDefault
        UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
            self.view.layoutIfNeeded()
            self.logo.transform = CGAffineTransform.identity
            self.pleaseText.alpha = 1
        }) { (_) in
        }
    }
    
    
    
    @IBAction func clearEmail(_ sender: Any) {
        self.emailTextField.text = nil
    }

    
    @IBAction func sendPressed(_ sender: Any) {
        if checkEmail() {
            self.resetPassword(email: self.emailTextField.text!)
        }
    }

    func resetPassword(email: String) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        view.isUserInteractionEnabled = false
        Auth0.authentication().resetPassword(email: email, connection: "Username-Password-Authentication").start { (result) in
            DispatchQueue.main.async {
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                self.view.isUserInteractionEnabled = true
            }
            switch result {
            case .success( _):
                DispatchQueue.main.async {
                    self.alertMessage(message: "Please check your email for instructions.", title: "Reset Password")
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.alertMessage(message: error.localizedDescription)
                }
            }
        }
        
        
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == self.emailTextField {
            if checkEmail() {
                self.sendPressed(self)
            }
        }
        
        return false
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        textField.textColor = UIColor.white
        return true
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
                self.closePressed(self)
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
                emailTextField.resignFirstResponder()
            }
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @IBAction func closePressed(_ sender: Any) {
        self.presentingViewController?.dismiss(animated: true, completion: { 
            
        })
    }

}
