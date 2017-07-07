//
//  ProfileViewController.swift
//  ImpactHub
//
//  Created by Niklas Alvaeus on 19/05/2017.
//  Copyright © 2017 Lightful Ltd. All rights reserved.
//

import UIKit
import SalesforceSDKCore
import Kingfisher

class ProfileViewController: UIViewController {
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()

        
        userName.text = SessionManager.shared.me?.fullName
        
        
        if let photoUrl = SessionManager.shared.me?.profilePicUrl {
            profileImageView.kf.setImage(with: photoUrl)
        }
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func logoutTapped(_ sender: Any) {
        SFAuthenticationManager.shared().logoutAllUsers()
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
