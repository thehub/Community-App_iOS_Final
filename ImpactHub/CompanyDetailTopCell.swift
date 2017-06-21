//
//  CompanyDetailTopCell.swift
//  ImpactHub
//
//  Created by Niklas on 18/05/2017.
//  Copyright © 2017 Lightful Ltd. All rights reserved.
//

import UIKit

class CompanyDetailTopCell: UICollectionViewCell {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var subNameLabel: UILabel!
    @IBOutlet weak var locationNameLabel: UILabel!
    @IBOutlet weak var facebookImageView: UIImageView!
    @IBOutlet weak var twitterImageView: UIImageView!
    @IBOutlet weak var fadeView: UIView!
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var linkedinImageView: UIImageView!
    @IBOutlet weak var instagramImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    var vm:CompanyDetailTopViewModel!

    func setup(vm: CompanyDetailTopViewModel) {
        self.vm = vm
        nameLabel.text = vm.company.name
        subNameLabel.text = vm.company.blurb
        profileImageView.image = UIImage(named: vm.company.photo)
        locationNameLabel.text = vm.locationNameLong
        logoImageView.image = UIImage(named: vm.company.logo)
        
    }
    
    let gradientLayer: CAGradientLayer = CAGradientLayer()
    
    override func draw(_ rect: CGRect) {
        gradientLayer.removeFromSuperlayer()
        let startingColorOfGradient = UIColor.init(white: 0.0, alpha: 0.2).cgColor
        let endingColorOFGradient = UIColor.init(white: 1.0, alpha: 1.0).cgColor
        gradientLayer.frame = self.fadeView.layer.bounds
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y:1.0)
        gradientLayer.colors = [startingColorOfGradient , endingColorOFGradient]
        fadeView.layer.insertSublayer(gradientLayer, at: 0)
    }

    
}
