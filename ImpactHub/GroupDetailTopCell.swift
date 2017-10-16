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
    
    var vm: GroupDetailTopViewModel?
    
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
        self.vm = vm
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
    
    @IBAction func backTap(_ sender: Any) {
        self.vm?.cellBackDelegate?.goBack()
    }
    
    @IBOutlet weak var fadeView: UIView!
    let gradientLayer: CAGradientLayer = CAGradientLayer()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        gradientLayer.removeFromSuperlayer()
        let startingColorOfGradient = UIColor(hexString: "252424").withAlphaComponent(0.0).cgColor
        let midColor = UIColor(hexString: "181818").withAlphaComponent(0.66).cgColor
        let endingColorOFGradient = UIColor(hexString: "252424").withAlphaComponent(1.0).cgColor
        gradientLayer.frame = self.bounds 
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y:1.0)
        gradientLayer.locations = [NSNumber.init(value: 0.0), NSNumber.init(value: 0.8), NSNumber.init(value: 1.0)]
        gradientLayer.colors = [startingColorOfGradient, midColor, endingColorOFGradient]
        fadeView.layer.insertSublayer(gradientLayer, at: 0)
        
    }

}
