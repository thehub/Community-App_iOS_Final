//
//  MemberDetailTopCell.swift
//  ImpactHub
//
//  Created by Niklas on 18/05/2017.
//  Copyright © 2017 Lightful Ltd. All rights reserved.
//

import UIKit

class ProjectDetailTopCell: UICollectionViewCell {

    @IBOutlet weak var imageViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var arrowImage: UIImageView!

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var jobLabel: UILabel!
    
    var vm: ProjectDetailTopViewModel?
    
    override func awakeFromNib() {
        super.awakeFromNib()

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
        
        self.clipsToBounds = false

    }

    func setup(vm: ProjectDetailTopViewModel) {
        self.vm = vm
        nameLabel.text = vm.project.name
        jobLabel.text = "by \(vm.project.companyName ?? "")"
        profileImageView.kf.setImage(with: vm.project.photoUrl)
        
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

    @IBAction func backTap(_ sender: Any) {
        self.vm?.cellBackDelegate?.goBack()
    }
    
}
