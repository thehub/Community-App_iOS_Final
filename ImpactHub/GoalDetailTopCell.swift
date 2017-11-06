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
    
    var vm: GoalDetailTopViewModel?
    
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
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        profileImageView.image = nil
    }

    
    func setup(vm: GoalDetailTopViewModel) {
        self.vm = vm
        nameLabel.text = vm.goal.name
        jobLabel.text = vm.goal.summary
        if let photoUrl = vm.goal.photoUrl {
            profileImageView.kf.setImage(with: photoUrl, options: [.transition(.fade(0.2))])
        }

        self.clipsToBounds = false
        self.arrowImage.layer.add(Animations.slideAnimation, forKey: "slideAnimation")
        
        self.didScrollWith(offsetY: -45)

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
