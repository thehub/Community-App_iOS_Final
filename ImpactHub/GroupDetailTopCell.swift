//
//  MemberDetailTopCell.swift
//  ImpactHub
//
//  Created by Niklas on 18/05/2017.
//  Copyright © 2017 Lightful Ltd. All rights reserved.
//

import UIKit

class GroupDetailTopCell: UICollectionViewCell {

    @IBOutlet weak var imageViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var arrowImage: UIImageView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var jobLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.clipsToBounds = false

        // Motion effect
        let m1 = UIInterpolatingMotionEffect(keyPath:"center.x", type:.tiltAlongHorizontalAxis)
        m1.maximumRelativeValue = 30.0
        m1.minimumRelativeValue = -30.0
        let m2 = UIInterpolatingMotionEffect(keyPath:"center.y", type:.tiltAlongVerticalAxis)
        m2.maximumRelativeValue = 30.0
        m2.minimumRelativeValue = -30.0
        let g = UIMotionEffectGroup()
        g.motionEffects = [m1,m2]
        nameLabel.addMotionEffect(g)
        jobLabel.addMotionEffect(g)
    }

    func setup(vm: GroupDetailTopViewModel) {
        nameLabel.text = vm.group.name
        jobLabel.text = vm.group.description ?? ""
        if let photoUrl = vm.group.photoUrl {
            profileImageView.kf.setImage(with: photoUrl)
        }
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
