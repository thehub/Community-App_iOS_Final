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
import PromiseKit
import UserNotifications



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
        
        loadMe() // Turn of for auth0
        
        self.observer = NotificationCenter.default.addObserver(forName: NSNotification.Name.onLogin, object: nil, queue: OperationQueue.main) { (_) in
            self.loadMe()
        }
    }
    
    var retries = 1
    
    func loadMe() {
        if let currentUser = SFUserAccountManager.sharedInstance().currentUser, currentUser.isSessionValid {
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
            print(currentUser.accountIdentity.userId)
            firstly {
                APIClient.shared.getMe(userId: currentUser.accountIdentity.userId)
                }.then { me -> Void in
                    SessionManager.shared.me = me
                    self.performSegue(withIdentifier: "ShowHome", sender: self)
                }.always {
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                }.catch { error in
                    debugPrint(error.localizedDescription)
                    if self.retries > 0 {
                        self.retries -= 1
                        let alert = UIAlertController(title: "Error", message: "Could not log in. Please try again.", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (_) in
                            self.loadMe()
                        }))
                        self.present(alert, animated: true, completion: nil)
                    }
                    else {
                        SFAuthenticationManager.shared().logoutAllUsers()
                    }
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        self.checkAccessToken() // turn on for auth0
    }
    
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
        print("haveSession")
        debugPrint(token)
        
        let authenticationManager = SFAuthenticationManager.shared()
        authenticationManager.oauthClientId = "3MVG9lcxCTdG2Vbsh1Tk8y8c1rJI3k2NcjhqU64_RUJL9FRsLMA.YWqHIpocRx.hDakLQbYS7eAB16YOMuPyL"
        authenticationManager.login(withJwtToken: token, completion: { (authInfo, userAccount) in
            SFUserAccountManager.sharedInstance().currentUser = userAccount
            print("Hurray!")
        }) { (authInfo, error) in
            debugPrint(error.localizedDescription)
        }
        
        
        // lightful-impacthub.cs88.force.com/services/oauth2/token
        
//        SFAuthenticationViewHandler
        
    
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
