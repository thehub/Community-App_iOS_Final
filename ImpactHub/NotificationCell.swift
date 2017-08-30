//
//  NotificationCell.swift
//  ImpactHub
//
//  Created by Niklas on 12/07/2017.
//  Copyright © 2017 Lightful Ltd. All rights reserved.
//

import UIKit

class NotificationCell: UICollectionViewCell {

    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        profileImageView.image = nil
    }

    func setUp(vm: NotificationViewModel) {
        
        if let profilePicUrl = vm.pushNotification.profilePicUrl {
            profileImageView.kf.setImage(with: profilePicUrl, placeholder: nil, options: nil, progressBlock: nil, completionHandler: { (image, error, cacheType, url) in
                if let error = error {
                    print(error.localizedDescription)
                }
            })
        }
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 0.82
        
        let attrString = NSMutableAttributedString(string: vm.pushNotification.message)
        attrString.addAttribute(NSParagraphStyleAttributeName, value:paragraphStyle, range:NSMakeRange(0, attrString.length))
        messageLabel.attributedText = attrString
        
//        messageLabel.text = "\(vm.pushNotification.message)"
        timeLabel.text = Utils.timeStringFromDate(date: vm.pushNotification.createdDate)
        
        self.iconImageView.image = vm.pushNotification.kind.getIconImage()
        
    }
    
}
