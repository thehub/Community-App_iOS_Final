//
//  MessageThreadMePicCell.swift
//  ImpactHub
//
//  Created by Niklas Alvaeus on 06/06/2017.
//  Copyright © 2017 Lightful Ltd. All rights reserved.
//

import UIKit
import Kingfisher

class MessageThreadMePicCell: UITableViewCell {

    @IBOutlet weak var profileImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()

        profileImageView.layer.cornerRadius = profileImageView.frame.size.width/2
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setUp(vm: MessagesThreadMePicVM) {
        
        if let photoUrl = vm.message.sender.photo?.smallPhotoUrl {
            profileImageView.kf.setImage(with: photoUrl)
        }
        
    }
    
}
