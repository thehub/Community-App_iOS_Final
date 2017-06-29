//
//  MemberDetailTopCell.swift
//  ImpactHub
//
//  Created by Niklas on 18/05/2017.
//  Copyright © 2017 Lightful Ltd. All rights reserved.
//

import UIKit

class GroupDetailTopCell: UICollectionViewCell {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var jobLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func setup(vm: GroupDetailTopViewModel) {
        nameLabel.text = vm.group.name
        jobLabel.text = vm.group.description ?? ""
        if let photoUrl = vm.group.photoUrl {
            profileImageView.kf.setImage(with: photoUrl)
        }
        
    }
    
    
    
}
