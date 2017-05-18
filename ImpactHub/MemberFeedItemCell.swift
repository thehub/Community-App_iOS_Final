//
//  MemberFeedItemCell.swift
//  ImpactHub
//
//  Created by Niklas on 18/05/2017.
//  Copyright © 2017 Lightful Ltd. All rights reserved.
//

import UIKit

class MemberFeedItemCell: UICollectionViewCell {

    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var textLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        profileImageView.layer.cornerRadius = profileImageView.frame.width/2
        profileImageView.clipsToBounds = true
    }
    
    func setUp(vm: MemberFeedItemViewModel) {
        nameLabel.text = vm.member.name
        profileImageView.image = UIImage(named: vm.member.photo)
        dateLabel.text = "4:15pm"
        textLabel.text = "Lorem ipsum dolor sit amet, habitasse a suspendisse et, nec suscipit imperdiet sed, libero mollis felis egestas vivamus velit."
        
    }
}
