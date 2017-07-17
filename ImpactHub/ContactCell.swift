//
//  MemberCollectionViewCell.swift
//  ImpactHub
//
//  Created by Niklas on 17/05/2017.
//  Copyright © 2017 Lightful Ltd. All rights reserved.
//

import UIKit
import PromiseKit


protocol ContactCellDelegate: class {
    func didApprove(member: Member)
    func didDecline(member: Member)
}

class ContactCell: UICollectionViewCell {
    
    weak var contactCellDelegate: ContactCellDelegate?
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var jobLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!

    @IBOutlet weak var connectionImageView: UIImageView!
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var locationNameLabel: UILabel!
    @IBOutlet weak var approveDeclineStack: UIStackView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        profileImageView.layer.cornerRadius = profileImageView.frame.width/2
        profileImageView.clipsToBounds = true
    }

    var vm: ContactViewModel!
    var inTransit = false
    
    func setUp(vm: ContactViewModel) {
        self.vm = vm
        nameLabel.text = vm.member.name
        jobLabel.text = vm.member.job
        if let photoUrl = vm.member.photoUrl {
            profileImageView.kf.setImage(with: photoUrl, placeholder: nil, options: nil, progressBlock: nil, completionHandler: { (image, error, cacheType, url) in
                if let error = error {
                    print(error.localizedDescription)
                }
            })
        }
        locationNameLabel.text = vm.member.locationName

        if let contactRequest = vm.member.contactRequest {
            switch contactRequest.status {
            case .outstanding, .declined:
                connectionImageView.image = UIImage(named: "waitingSmall")
                connectionImageView.isHidden = false
                approveDeclineStack.isHidden = true
            case .approved, .notRequested:
                connectionImageView.image = UIImage(named: "memberConnected")
                connectionImageView.isHidden = false
                approveDeclineStack.isHidden = true
            case .approveDecline:
                connectionImageView.isHidden = true
                approveDeclineStack.isHidden = false
            }
        }
        else {
            debugPrint("Error no contact Request on VM")
        }
        
    }

    
    
    @IBAction func approveTap(_ sender: Any) {
        guard let contactRequest = vm?.member.contactRequest else {
            print(("Error no member.contactRequest"))
            return
        }
        if inTransit {
            return
        }
        inTransit = true
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        firstly {
            APIClient.shared.updateDMRequest(id: contactRequest.id, status: DMRequest.Satus.approved)
            }.then { result -> Void in
                contactRequest.status = .approved
                self.contactCellDelegate?.didApprove(member: self.vm.member)
            }.always {
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                self.inTransit = false
            }.catch { error in
                debugPrint(error.localizedDescription)
                let alert = UIAlertController(title: "Error", message: "Could not approve request. Please try again.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func declineTap(_ sender: Any) {
        guard let contactRequest = vm?.member.contactRequest else {
            print(("Error no member.contactRequest"))
            return
        }
        if inTransit {
            return
        }
        inTransit = true
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        firstly {
            APIClient.shared.updateDMRequest(id: contactRequest.id, status: DMRequest.Satus.declined)
            }.then { result -> Void in
                contactRequest.status = .declined
                self.contactCellDelegate?.didDecline(member: self.vm.member)
            }.always {
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                self.inTransit = false
            }.catch { error in
                debugPrint(error.localizedDescription)
                let alert = UIAlertController(title: "Error", message: "Could not decline request. Please try again.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
        }
    }
    
    override func draw(_ rect: CGRect) {
        self.bgView.clipsToBounds = false
        self.bgView.layer.shadowColor = UIColor(hexString: "D5D5D5").cgColor
        self.bgView.layer.shadowOffset = CGSize(width: 0, height: 5)
        self.bgView.layer.shadowOpacity = 0.42
        self.bgView.layer.shadowPath = UIBezierPath(rect: self.bgView.bounds).cgPath
        self.bgView.layer.shadowRadius = 10.0
        
    }
    
    

}
