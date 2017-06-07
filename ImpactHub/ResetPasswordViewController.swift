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

    @IBOutlet weak var logo: UIImageView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var sendButton: WhiteButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.modalPresentationCapturesStatusBarAppearance = true

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @IBAction func closePressed(_ sender: Any) {
        self.presentingViewController?.dismiss(animated: true, completion: { 
            
        })
    }

}
