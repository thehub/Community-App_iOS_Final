//
//  ViewController.swift
//  ImpactHub
//
//  Created by Niklas on 17/05/2017.
//  Copyright © 2017 Lightful Ltd. All rights reserved.
//

import UIKit
import SalesforceSDKCore
import Lock
import Auth0



class ViewController: UIViewController {
    
    var observer: NSObjectProtocol?
    
    var sessionManager: SessionManager!

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
        
        // Do any additional setup after loading the view.
        if let currentUser = SFUserAccountManager.sharedInstance().currentUser, currentUser.isSessionValid {
            self.performSegue(withIdentifier: "ShowHome", sender: self)
        }
        //        else {
        //            self.performSegue(withIdentifier: "ShowIntro", sender: self)
        //        }
        
        
        self.observer = NotificationCenter.default.addObserver(forName: NSNotification.Name.onLogin, object: nil, queue: OperationQueue.main) { (_) in
            self.performSegue(withIdentifier: "ShowHome", sender: self)
        }
    }
    
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//        self.checkAccessToken()
//    }
    
    deinit {
        if let observer = self.observer {
            NotificationCenter.default.removeObserver(observer, name: NSNotification.Name.onLogin, object: nil)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    var didShow = false
    
    var controller: UIViewController?
    
    func showLoginController(withTouch: Bool = true) {
        self.performSegue(withIdentifier: "ShowLogin", sender: self)
    }
    
    func haveSession() {
        guard let token = sessionManager.token else {
            showLoginController()
            return
        }
        debugPrint(token)
        
        let authenticationManager = SFAuthenticationManager.shared()
//        authenticationManager.oauthClientId = ""
        SFAuthenticationManager.shared().login(withJwtToken: token, completion: { (authInfo, userAccount) in
            SFUserAccountManager.sharedInstance().currentUser = userAccount
            print("Hurray!")
        }) { (authInfo, error) in
            debugPrint(error.localizedDescription)
        }
        
        
    
    }
    
    // MARK: - Private
    
    fileprivate func showMissingProfileOrTokenAlert(withTouch: Bool = true) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Error", message: "Could not login. Please try again.", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (alertAction) in
                self.showLoginController(withTouch: withTouch)
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    
    fileprivate func checkAccessToken() {
        
        sessionManager.refresh({ (error) in
            DispatchQueue.main.async {
                if let error = error {
                    debugPrint(error.localizedDescription)
                    self.showLoginController()
                    return
                }
                else {
                    self.haveSession()
                }
            }
        })
        
        
        
        //        sessionManager.retrieveProfile({ (error) in
        //            DispatchQueue.main.async {
        //                if let error = error {
        //                    debugPrint(error.localizedDescription)
        //                    self.showLoginController()
        //                    return
        //                }
        //                else {
        //                    self.haveSession()
        //                }
        //            }
        //        })
    }
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    
}
