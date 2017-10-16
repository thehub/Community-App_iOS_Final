//
//  CompanyCollectionViewCell.swift
//  ImpactHub
//
//  Created by Niklas Alvaeus on 19/05/2017.
//  Copyright © 2017 Lightful Ltd. All rights reserved.
//

import UIKit
import Kingfisher

class CompanyCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var bigImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var companyNameLabel: UILabel!
    @IBOutlet weak var locationNameLabel: UILabel!
    @IBOutlet weak var memberCountLabel: UILabel!
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var logoImageContainer: UIView!
    
    @IBOutlet weak var redBottomView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        bigImageView.image = nil
        logoImageView.image = nil
    }

    
    func setUp(vm: CompanyViewModel) {
        if let photoUrl = vm.company.photoUrl {
            print(photoUrl)
            bigImageView.kf.setImage(with: photoUrl, placeholder: nil, options: [.transition(.fade(0.2))], progressBlock: nil, completionHandler: { (image, error, cache, url) in
                print(error?.localizedDescription)
            })
        }

        logoImageContainer.isHidden = true
        if let logoUrl = vm.company.logoUrl {
            logoImageView.kf.setImage(with: logoUrl, placeholder: nil, options: [.transition(.fade(0.2))], progressBlock: nil, completionHandler: { (image, error, cache, url) in
                if error != nil {
                    self.logoImageContainer.isHidden = true
                }
                else {
                    self.logoImageContainer.isHidden = false
                }
            })
        }
        nameLabel.text = vm.company.sector
        companyNameLabel.text = vm.company.name
        locationNameLabel.text = vm.company.locationName ?? ""
        memberCountLabel.text = vm.company.size ?? ""
    }
    
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        build()
    }

    func build() {
        self.bgView.clipsToBounds = false
        self.bgView.layer.shadowColor = UIColor(hexString: "D5D5D5").cgColor
        self.bgView.layer.shadowOffset = CGSize(width: 0, height: 5)
        self.bgView.layer.shadowOpacity = 0.42
        self.bgView.layer.shadowPath = UIBezierPath(rect: self.bgView.bounds).cgPath
        self.bgView.layer.shadowRadius = 10.0
        bigImageView.round(corners:[.topLeft, .topRight], radius: 10)
        
        redBottomView.round(corners:[.bottomLeft, .bottomRight], radius: 10)

        logoImageView.layer.cornerRadius = 42

        logoImageContainer.layer.cornerRadius = 42
        self.logoImageContainer.clipsToBounds = false
        self.logoImageContainer.layer.shadowColor = UIColor(hexString: "D5D5D5").cgColor
        self.logoImageContainer.layer.shadowOffset = CGSize(width: 0, height: 3)
        self.logoImageContainer.layer.shadowOpacity = 0.32
        self.logoImageContainer.layer.shadowPath = UIBezierPath(roundedRect: self.logoImageView.bounds, cornerRadius: 42).cgPath
        self.logoImageContainer.layer.shadowRadius = 6.0
        
        logoImageContainer.layer.shouldRasterize = true
        logoImageContainer.layer.rasterizationScale = UIScreen.main.scale
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        build()
    }
}
