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
    @IBOutlet weak var jobTitleLabel: UILabel!
    
    @IBOutlet weak var locationLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        userName.text = SessionManager.shared.me?.member.name
        
        jobTitleLabel.text = SessionManager.shared.me?.member.job ?? ""
        locationLabel.text = SessionManager.shared.me?.member.locationName ?? ""
        
        if let photoUrl = SessionManager.shared.me?.member.photoUrl {
            profileImageView.kf.setImage(with: photoUrl)
        }
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)

    }

    
    @IBAction func logoutTapped(_ sender: Any) {
        if let vc = UIApplication.shared.windows.first?.rootViewController as? UINavigationController {
            vc.popToRootViewController(animated: true)
            vc.dismiss(animated: true, completion: {
            })
            SFAuthenticationManager.shared().logoutAllUsers()
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: self)
        if segue.identifier == "ShowMember" {
            if let vc = segue.destination as? MemberViewController {
                vc.member = SessionManager.shared.me?.member
            }
        }
    }
}
