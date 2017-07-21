//
//  ContactIncommingViewController.swift
//  ImpactHub
//
//  Created by Niklas Alvaeus on 18/07/2017.
//  Copyright © 2017 Lightful Ltd. All rights reserved.
//

import UIKit
import PromiseKit

class ContactIncommingViewController: UIViewController {

    var member: Member?
    
    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var messageContainerView: UIView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = member?.name ?? "Member"
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)

        if let photoUrl = member?.photoUrl {
            profileImageView.kf.setImage(with: photoUrl, placeholder: nil, options: nil, progressBlock: nil, completionHandler: { (image, error, cacheType, url) in
                if let error = error {
                    print(error.localizedDescription)
                }
            })
        }
        
        self.messageContainerView.clipsToBounds = true
        self.messageLabel.text = member?.contactRequest?.message ?? ""
        
        if let date = member?.contactRequest?.createdDate {
            self.timeLabel.text = Utils.timeStringFromDate(date: date)
        }
        else {
            self.timeLabel.text = nil
        }
    
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.messageContainerView.round(corners: [.topRight, .bottomRight, .bottomLeft], radius: 20)
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    var inTransit = false
    
    @IBAction func approveTap(_ sender: Any) {
        guard let member = self.member else {
            debugPrint("No member set")
            return
        }
        guard let contactRequest = member.contactRequest else {
            print(("Error no member.contactRequest"))
            return
        }
        if inTransit {
            return
        }
        inTransit = true
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        firstly {
            APIClient.shared.updateDMRequest(id: contactRequest.id, status: DMRequest.Satus.approved, pushUserId: member.userId)
            }.then { result -> Void in
                self.navigationController?.popViewController(animated: true)
            }.always {
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                self.inTransit = false
            }.catch { error in
                debugPrint(error.localizedDescription)
                let alert = UIAlertController(title: "Error", message: "Could not approve request. Please try again.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func declineTap(_ sender: Any) {
        guard let member = self.member else {
            debugPrint("No member set")
            return
        }
        guard let contactRequest = member.contactRequest else {
            print(("Error no member.contactRequest"))
            return
        }
        if inTransit {
            return
        }
        inTransit = true
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        firstly {
            APIClient.shared.updateDMRequest(id: contactRequest.id, status: DMRequest.Satus.declined, pushUserId: member.userId)
            }.then { result -> Void in
                self.navigationController?.popViewController(animated: true)
            }.always {
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                self.inTransit = false
            }.catch { error in
                debugPrint(error.localizedDescription)
                let alert = UIAlertController(title: "Error", message: "Could not decline request. Please try again.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: self)
        if segue.identifier == "ShowMember" {
            if let vc = segue.destination as? MemberViewController, let member = self.member {
                vc.member = member
            }
        }
    }

    
}
