//
//  MemberCollectionViewCell.swift
//  ImpactHub
//
//  Created by Niklas on 17/05/2017.
//  Copyright © 2017 Lightful Ltd. All rights reserved.
//

import UIKit

class JobCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var profileImageShadowView: UIView!
    @IBOutlet weak var fulltimeLabel: UILabel!
    @IBOutlet weak var companyLabel: UILabel!
    @IBOutlet weak var connectionImageView: UIImageView!
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var locationNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        profileImageView.layer.cornerRadius = 10
        profileImageView.clipsToBounds = true
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        profileImageView.image = nil
    }


    func setUp(vm: JobViewModel) {
        companyLabel.text = vm.job.company.name
        nameLabel.text = vm.job.name
        fulltimeLabel.text = vm.job.type
        if let logoUrl = vm.job.logoUrl {
            print(logoUrl)
            profileImageView.kf.setImage(with: logoUrl, placeholder: nil, options: nil, progressBlock: nil, completionHandler: { (image, error, cache, url) in
                print(error?.localizedDescription)
            })
        }
        locationNameLabel.text = vm.job.locationName

    }

    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        build()

    }
    
    func build() {
        bgView.clipsToBounds = false
        bgView.layer.shadowColor = UIColor(hexString: "D5D5D5").cgColor
        bgView.layer.shadowOffset = CGSize(width: 0, height: 5)
        bgView.layer.shadowOpacity = 0.42
        bgView.layer.shadowPath = UIBezierPath(rect: self.bgView.bounds).cgPath
        bgView.layer.shadowRadius = 10.0
        
        profileImageView.clipsToBounds = true
        profileImageView.layer.cornerRadius = 10
        
        profileImageShadowView.layer.cornerRadius = 10
        profileImageShadowView.layer.shadowColor = UIColor(hexString: "D5D5D5").cgColor
        profileImageShadowView.layer.shadowOffset = CGSize(width: 0, height: 5)
        profileImageShadowView.layer.shadowOpacity = 0.42
        profileImageShadowView.layer.shadowPath = UIBezierPath(rect: self.profileImageView.bounds).cgPath
        profileImageShadowView.layer.shadowRadius = 10.0
        profileImageShadowView.layer.shouldRasterize = true
        profileImageShadowView.layer.rasterizationScale = UIScreen.main.scale
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        build()
    }
    

}
