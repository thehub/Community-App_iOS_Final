//
//  MemberCollectionViewCell.swift
//  ImpactHub
//
//  Created by Niklas on 17/05/2017.
//  Copyright © 2017 Lightful Ltd. All rights reserved.
//

import UIKit

class ContactCell: UICollectionViewCell {
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

    func setUp(vm: ContactViewModel) {
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

        
        if vm.member.contactRequest?.status == .outstanding || vm.member.contactRequest?.status == .declined {
            connectionImageView.image = UIImage(named: "waitingSmall")
        }
        else {
            connectionImageView.image = UIImage(named: "memberConnected")
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
