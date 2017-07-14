//
//  NotificationCell.swift
//  ImpactHub
//
//  Created by Niklas on 12/07/2017.
//  Copyright © 2017 Lightful Ltd. All rights reserved.
//

import UIKit

class NotificationCell: UICollectionViewCell {

    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setUp(vm: NotificationViewModel) {
        
        if let profilePicUrl = vm.pushNotification.profilePicUrl {
            profileImageView.kf.setImage(with: profilePicUrl, placeholder: nil, options: nil, progressBlock: nil, completionHandler: { (image, error, cacheType, url) in
                if let error = error {
                    print(error.localizedDescription)
                }
            })
        }
        messageLabel.text = "\(vm.pushNotification.message)"
        timeLabel.text = Utils.timeStringFromDate(date: vm.pushNotification.createdDate)
    }
    
}