//
//  MemberCollectionViewCell.swift
//  ImpactHub
//
//  Created by Niklas on 17/05/2017.
//  Copyright © 2017 Lightful Ltd. All rights reserved.
//

import UIKit

class MemberCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var jobLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!

    @IBOutlet weak var locationNameLabel: UILabel!
    @IBOutlet weak var blurbLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        profileImageView.layer.cornerRadius = profileImageView.frame.width/2
        profileImageView.clipsToBounds = true
    }

    func setUp(vm: MemberViewModel) {
        nameLabel.text = vm.member.name
        jobLabel.text = vm.member.job
        profileImageView.image = UIImage(named: vm.member.photo)
        blurbLabel.text = vm.member.blurb
        locationNameLabel.text = vm.member.locationName
    }
    

}
