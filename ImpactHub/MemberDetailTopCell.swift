//
//  MemberDetailTopCell.swift
//  ImpactHub
//
//  Created by Niklas on 18/05/2017.
//  Copyright © 2017 Lightful Ltd. All rights reserved.
//

import UIKit
import SafariServices

class MemberDetailTopCell: UICollectionViewCell {

    @IBOutlet weak var fadeViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var jobLabel: UILabel!
    @IBOutlet weak var locationNameLabel: UILabel!
    @IBOutlet weak var blurbLabel: UILabel!
    @IBOutlet weak var facebookImageView: UIImageView!
    @IBOutlet weak var twitterImageView: UIImageView!
    @IBOutlet weak var fadeView: UIView!
    
    @IBOutlet weak var facebookButton: Button!
    @IBOutlet weak var twitterButton: Button!
    @IBOutlet weak var linkedinButton: Button!
    @IBOutlet weak var instagramButton: Button!
    @IBOutlet weak var arrowImage: UIImageView!

    var imageViewHeightConstraintDefault: CGFloat = 0.5
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    var vm: MemberDetailTopViewModel?
    
    func setup(vm: MemberDetailTopViewModel) {
        self.vm = vm
        nameLabel.text = vm.member.name
        jobLabel.text = vm.member.job
        if let photoUrl = vm.member.photoUrl {
            print(photoUrl)
            profileImageView.kf.setImage(with: photoUrl, options: [.transition(.fade(0.2))])
        }
        blurbLabel.text = vm.member.statusUpdate
        locationNameLabel.text = vm.locationNameLong
        
        if vm.member.social?.facebook != nil {
            facebookButton.isHidden = false
        }
        else {
            facebookButton.isHidden = true
        }
        
        if vm.member.social?.twitter != nil {
            twitterButton.isHidden = false
        }
        else {
            twitterButton.isHidden = true
        }
        
        if vm.member.social?.linkedIn != nil {
            linkedinButton.isHidden = false
        }
        else {
            linkedinButton.isHidden = true
        }
        
        if vm.member.social?.instagram != nil {
            instagramButton.isHidden = false
        }
        else {
            instagramButton.isHidden = true
        }
        
        self.clipsToBounds = false

        imageViewHeightConstraintDefault = self.imageViewHeightConstraint.constant
        
        self.arrowImage.layer.add(Animations.slideAnimation, forKey: "slideAnimation")

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

    func didScrollWith(offsetY: CGFloat) {
        
        if offsetY < 0 {
            self.imageViewTopConstraint.constant = offsetY
            self.fadeViewBottomConstraint.constant = -offsetY
            self.imageViewHeightConstraint.constant = imageViewHeightConstraintDefault + ((abs(offsetY) / self.frame.height) * 500)
        }
        else {
            self.imageViewHeightConstraint.constant = imageViewHeightConstraintDefault
            self.imageViewTopConstraint.constant = 0
            self.fadeViewBottomConstraint.constant = 0
        }
    }
    
    @IBAction func onInstagram(_ sender: Any) {
        if let url = vm?.member.social?.instagram {
            let svc = SFSafariViewController(url: url)
            UIApplication.shared.keyWindow?.rootViewController?.present(svc, animated: true, completion: nil)
        }
    }
    
    @IBAction func onLinkedin(_ sender: Any) {
        if let url = vm?.member.social?.linkedIn {
            let svc = SFSafariViewController(url: url)
            UIApplication.shared.keyWindow?.rootViewController?.present(svc, animated: true, completion: nil)
        }
    }
    
    @IBAction func onTwitter(_ sender: Any) {
        if let twitter = vm?.member.social?.twitter, let url = URL(string: "https://twitter.com/\(twitter)") {
            let svc = SFSafariViewController(url: url)
            UIApplication.shared.keyWindow?.rootViewController?.present(svc, animated: true, completion: nil)
        }
    }
    
    @IBAction func onFacebook(_ sender: Any) {
        if let url = vm?.member.social?.facebook {
            let svc = SFSafariViewController(url: url)
            UIApplication.shared.keyWindow?.rootViewController?.present(svc, animated: true, completion: nil)
        }
    }
    
    @IBAction func backTap(_ sender: Any) {
        self.vm?.cellBackDelegate?.goBack()
    }
}
