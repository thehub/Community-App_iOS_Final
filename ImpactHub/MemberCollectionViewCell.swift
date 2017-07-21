//
//  MemberCollectionViewCell.swift
//  ImpactHub
//
//  Created by Niklas on 17/05/2017.
//  Copyright © 2017 Lightful Ltd. All rights reserved.
//

import UIKit

protocol MemberCollectionViewCellDelegate: class {
    func wantsToCreateNewMessage(member: Member)
    func wantsToSendContactRequest(member: Member)
}

class MemberCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var openMessageButton: UIButton!
    
    weak var memberCollectionViewCellDelegate: MemberCollectionViewCellDelegate?

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var jobLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!

    @IBOutlet weak var connectionImageView: UIImageView!
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var locationNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        profileImageView.layer.cornerRadius = profileImageView.frame.width/2
        profileImageView.clipsToBounds = true
    }

    @IBAction func openMessageTap(_ sender: Any) {
        guard let member = vm?.member else { return }
        
        if member.contactRequest?.status == .outstanding {
            memberCollectionViewCellDelegate?.wantsToSendContactRequest(member: member)
        }
        else if member.contactRequest?.status == .approved {
            memberCollectionViewCellDelegate?.wantsToCreateNewMessage(member: member)
        }
    }
    
    var vm:MemberViewModel?
    
    func setUp(vm: MemberViewModel) {
        nameLabel.text = vm.member.name
        jobLabel.text = vm.member.job
        if let photoUrl = vm.member.photoUrl {
            print(photoUrl)
            profileImageView.kf.setImage(with: photoUrl, placeholder: nil, options: nil, progressBlock: nil, completionHandler: { (image, error, cacheType, url) in
                if let error = error {
                    print(error.localizedDescription)
                }
            })
        }
        locationNameLabel.text = vm.member.locationName

        
        if vm.member.contactRequest?.status == .outstanding || vm.member.contactRequest?.status == .declined || vm.member.contactRequest?.status == .approveDecline {
            connectionImageView.image = UIImage(named: "waitingSmall")
            openMessageButton.isHidden = true
        }
        else {
            connectionImageView.image = UIImage(named: "memberConnected")
            openMessageButton.isHidden = false
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
