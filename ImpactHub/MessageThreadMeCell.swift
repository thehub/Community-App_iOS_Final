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
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setUp(vm: MessagesThreadMeVM) {
        messageLabel.text = vm.message.text
        
        // TODO: Where is the draw call for this?
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.messageLabelContainer.round(corners: vm.corners, radius: 20)
        }
        
    }

}
