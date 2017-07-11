//
//  MemberDetailTopCell.swift
//  ImpactHub
//
//  Created by Niklas on 18/05/2017.
//  Copyright © 2017 Lightful Ltd. All rights reserved.
//

import UIKit

class GoalDetailTopCell: UICollectionViewCell {

    @IBOutlet weak var imageViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var arrowImage: UIImageView!

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var jobLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func setup(vm: GoalDetailTopViewModel) {
        nameLabel.text = vm.goal.name
        jobLabel.text = vm.goal.summary
        profileImageView.image = UIImage(named: vm.goal.photo)  // TODO: Once in salesforce
        
        self.clipsToBounds = false
        
        self.arrowImage.layer.add(Animations.slideAnimation, forKey: "slideAnimation")
        
    }

    
    func didScrollWith(offsetY: CGFloat) {
        if offsetY < 0 {
            self.imageViewTopConstraint.constant = offsetY
        }
        else {
            self.imageViewTopConstraint.constant = 0
        }
    }

    
}
