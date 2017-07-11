//
//  CompanyDetailTopCell.swift
//  ImpactHub
//
//  Created by Niklas on 18/05/2017.
//  Copyright © 2017 Lightful Ltd. All rights reserved.
//

import UIKit
import Kingfisher
import SafariServices


class CompanyDetailTopCell: UICollectionViewCell {

    @IBOutlet weak var imageViewTopConstraint: NSLayoutConstraint!

    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var subNameLabel: UILabel!
    @IBOutlet weak var locationNameLabel: UILabel!
    @IBOutlet weak var fadeView: UIView!
    @IBOutlet weak var logoImageView: UIImageView!

    
    @IBOutlet weak var facebookButton: Button!
    @IBOutlet weak var twitterButton: Button!
    @IBOutlet weak var linkedinButton: Button!
    @IBOutlet weak var instagramButton: Button!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    var vm:CompanyDetailTopViewModel!

    func setup(vm: CompanyDetailTopViewModel) {
        self.vm = vm
        nameLabel.text = vm.company.name
        subNameLabel.text = vm.company.blurb
        if let photoUrl = vm.company.photoUrl {
            profileImageView.kf.setImage(with: photoUrl)
        }
        locationNameLabel.text = vm.company.locationName
        if let logoUrl = vm.company.logoUrl {
            logoImageView.kf.setImage(with: logoUrl)
        }
        
        if vm.company.social?.facebook != nil {
            facebookButton.isHidden = false
        }
        else {
            facebookButton.isHidden = true
        }
        
        if vm.company.social?.twitter != nil {
            twitterButton.isHidden = false
        }
        else {
            twitterButton.isHidden = true
        }

        if vm.company.social?.linkedIn != nil {
            linkedinButton.isHidden = false
        }
        else {
            linkedinButton.isHidden = true
        }

        if vm.company.social?.instagram != nil {
            instagramButton.isHidden = false
        }
        else {
            instagramButton.isHidden = true
        }
        
        self.clipsToBounds = false
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
    
    func didScrollWith(offsetY: CGFloat) {
        if offsetY < 0 {
            self.imageViewTopConstraint.constant = offsetY
        }
        else {
            self.imageViewTopConstraint.constant = 0
        }
    }
    
    
    @IBAction func onInstagram(_ sender: Any) {
        if let url = vm.company.social?.instagram {
            let svc = SFSafariViewController(url: url)
            UIApplication.shared.keyWindow?.rootViewController?.present(svc, animated: true, completion: nil)
        }
    }
    
    @IBAction func onLinkedin(_ sender: Any) {
        if let url = vm.company.social?.linkedIn {
            let svc = SFSafariViewController(url: url)
            UIApplication.shared.keyWindow?.rootViewController?.present(svc, animated: true, completion: nil)
        }
    }
    
    @IBAction func onTwitter(_ sender: Any) {
        if let twitter = vm.company.social?.twitter, let url = URL(string: "https://twitter.com/\(twitter)") {
            let svc = SFSafariViewController(url: url)
            UIApplication.shared.keyWindow?.rootViewController?.present(svc, animated: true, completion: nil)
        }
    }

    @IBAction func onFacebook(_ sender: Any) {
        if let url = vm.company.social?.facebook {
            let svc = SFSafariViewController(url: url)
            UIApplication.shared.keyWindow?.rootViewController?.present(svc, animated: true, completion: nil)
        }
    }
    
    
}





