//
//  MessageThreadThemCell.swift
//  ImpactHub
//
//  Created by Niklas Alvaeus on 06/06/2017.
//  Copyright © 2017 Lightful Ltd. All rights reserved.
//

import UIKit

class MessageThreadThemCell: UITableViewCell {

    @IBOutlet weak var messageLabelContainer: UIView!
    @IBOutlet weak var messageLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func setUp(vm: MessagesThreadThemVM) {
        
        messageLabel.text = vm.message.text
        
        // TODO: Where is the draw call for this?
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
            self.messageLabelContainer.round(corners: vm.corners, radius: 20)
        }

        
    }


}
