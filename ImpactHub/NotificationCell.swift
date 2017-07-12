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
        messageLabel.text = "\(vm.pushNotification.kind.getParameter()) \(vm.pushNotification.fromUserId) \(vm.pushNotification.relatedId)"
        timeLabel.text = Utils.timeStringFromDate(date: vm.pushNotification.createdDate)
    }
    
}
