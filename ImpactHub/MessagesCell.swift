//
//  MessagesCell.swift
//  ImpactHub
//
//  Created by Niklas Alvaeus on 06/06/2017.
//  Copyright © 2017 Lightful Ltd. All rights reserved.
//

import UIKit

class MessagesCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var unreadLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imageView.layer.cornerRadius = imageView.frame.width/2
        imageView.clipsToBounds = true
    }
    
    func setUp(vm: MessagesVM) {
        nameLabel.text = vm.conversation.latestMessage.sender.displayName
        textLabel.text = vm.conversation.latestMessage.text
        timeLabel.text = Utils.timeStringFromDate(date: vm.conversation.latestMessage.sentDate)
        unreadLabel.isHidden = vm.conversation.read
        imageView.kf.setImage(with: vm.conversation.latestMessage.sender.photo?.smallPhotoUrl)
        
    }
    
    
    
}
