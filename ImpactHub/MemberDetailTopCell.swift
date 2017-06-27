//
//  MemberDetailTopCell.swift
//  ImpactHub
//
//  Created by Niklas on 18/05/2017.
//  Copyright © 2017 Lightful Ltd. All rights reserved.
//

import UIKit

class MemberDetailTopCell: UICollectionViewCell {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var jobLabel: UILabel!
    @IBOutlet weak var locationNameLabel: UILabel!
    @IBOutlet weak var blurbLabel: UILabel!
    @IBOutlet weak var facebookImageView: UIImageView!
    @IBOutlet weak var twitterImageView: UIImageView!
    @IBOutlet weak var fadeView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func setup(vm: MemberDetailTopViewModel) {
        nameLabel.text = vm.member.name
        jobLabel.text = vm.jobDescriptionLong
        if let photoUrl = vm.member.photoUrl {
            profileImageView.kf.setImage(with: photoUrl)
        }
        blurbLabel.text = vm.member.blurb
        locationNameLabel.text = vm.locationNameLong
        
    }
    
    let gradientLayer: CAGradientLayer = CAGradientLayer()
    
    override func draw(_ rect: CGRect) {
        gradientLayer.removeFromSuperlayer()
        let startingColorOfGradient = UIColor.init(white: 1.0, alpha: 0.0).cgColor
        let endingColorOFGradient = UIColor.init(white: 1.0, alpha: 1.0).cgColor
        gradientLayer.frame = self.fadeView.layer.bounds
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y:0.3)
        gradientLayer.colors = [startingColorOfGradient , endingColorOFGradient]
        fadeView.layer.insertSublayer(gradientLayer, at: 0)
    }

    
    
}
