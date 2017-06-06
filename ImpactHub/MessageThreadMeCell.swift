//
//  MessageThreadMeCell.swift
//  ImpactHub
//
//  Created by Niklas Alvaeus on 06/06/2017.
//  Copyright © 2017 Lightful Ltd. All rights reserved.
//

import UIKit

class MessageThreadMeCell: UITableViewCell {

    @IBOutlet weak var messageLabelContainer: UIView!
    @IBOutlet weak var messageLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        messageLabelContainer.layer.cornerRadius = 20
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
//        messageLabelContainer.roundCorners([.topRight, .bottomRight, .bottomLeft], radius: 10)
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setUp(vm: MessagesThreadMeVM) {
        
        messageLabel.text = vm.message.text

    }

}
