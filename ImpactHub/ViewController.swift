//
//  ViewController.swift
//  ImpactHub
//
//  Created by Niklas on 17/05/2017.
//  Copyright © 2017 Lightful Ltd. All rights reserved.
//

import UIKit
import SalesforceSDKCore


class ViewController: UIViewController {
    
    var observer: NSObjectProtocol?
    
    
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
    
    
    deinit {
        if let observer = self.observer {
            NotificationCenter.default.removeObserver(observer, name: NSNotification.Name.onLogin, object: nil)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
