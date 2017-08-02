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
    }

    
    func setUp(vm: CompanyViewModel) {
        if let photoUrl = vm.company.photoUrl {
            bigImageView.kf.setImage(with: photoUrl)
        }

        if let logoUrl = vm.company.logoUrl {
            logoImageView.kf.setImage(with: logoUrl)
        }
        
        nameLabel.text = vm.company.sector
        companyNameLabel.text = vm.company.name
        locationNameLabel.text = vm.company.locationName ?? ""
        memberCountLabel.text = vm.company.size ?? ""
    }
    
    
    override func draw(_ rect: CGRect) {
        self.bgView.clipsToBounds = false
        self.bgView.layer.shadowColor = UIColor(hexString: "D5D5D5").cgColor
        self.bgView.layer.shadowOffset = CGSize(width: 0, height: 5)
        self.bgView.layer.shadowOpacity = 0.42
        self.bgView.layer.shadowPath = UIBezierPath(rect: self.bgView.bounds).cgPath
        self.bgView.layer.shadowRadius = 10.0
        bigImageView.round(corners:[.topLeft, .topRight], radius: 10)

        redBottomView.round(corners:[.bottomLeft, .bottomRight], radius: 10)

        logoImageContainer.layer.cornerRadius = 44
        self.logoImageContainer.clipsToBounds = false
        self.logoImageContainer.layer.shadowColor = UIColor(hexString: "D5D5D5").cgColor
        self.logoImageContainer.layer.shadowOffset = CGSize(width: 0, height: 3)
        self.logoImageContainer.layer.shadowOpacity = 0.32
        self.logoImageContainer.layer.shadowPath = UIBezierPath(rect: self.logoImageContainer.bounds).cgPath
        self.logoImageContainer.layer.shadowRadius = 6.0
        logoImageView.layer.cornerRadius = 44
        
        logoImageContainer.layer.shouldRasterize = true
        logoImageContainer.layer.rasterizationScale = UIScreen.main.scale


    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
}
