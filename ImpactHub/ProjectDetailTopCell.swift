//
//  MemberDetailTopCell.swift
//  ImpactHub
//
//  Created by Niklas on 18/05/2017.
//  Copyright © 2017 Lightful Ltd. All rights reserved.
//

import UIKit

class ProjectDetailTopCell: UICollectionViewCell {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var jobLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func setup(vm: ProjectDetailTopViewModel) {
        nameLabel.text = vm.project.name
        jobLabel.text = "by Equinox Consulting" // vm.jobDescriptionLong
//        profileImageView.image = UIImage(named: vm.member.photo)
        
    }
    
//    override func draw(_ rect: CGRect) {
//        
//    }

    
    
}
