//
//  MessageThreadMePicCell.swift
//  ImpactHub
//
//  Created by Niklas Alvaeus on 06/06/2017.
//  Copyright © 2017 Lightful Ltd. All rights reserved.
//

import UIKit
import Kingfisher

class MessageThreadMeTimeCell: UITableViewCell {

    @IBOutlet weak var timeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setUp(vm: MessagesThreadMeTimeVM) {
        
        self.timeLabel.text = Utils.timeStringFromDate(date: vm.message.sentDate)
        
    }
    
}
