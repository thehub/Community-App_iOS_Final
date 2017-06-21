//
//  CompanyCollectionViewCell.swift
//  ImpactHub
//
//  Created by Niklas Alvaeus on 19/05/2017.
//  Copyright © 2017 Lightful Ltd. All rights reserved.
//

import UIKit

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
    
    func setUp(vm: CompanyViewModel) {
        bigImageView.image = UIImage(named: "projectImage")
        
        logoImageView.image = UIImage(named: "companyLogo")
        
        nameLabel.text = "Zero to one: new startups and Innovative Ideas"
        companyNameLabel.text = "Equinox Consulting"
        locationNameLabel.text = "London, UK"
        memberCountLabel.text = "10 - 50"
    }
    
    
    override func draw(_ rect: CGRect) {
        self.bgView.clipsToBounds = false
        self.bgView.layer.shadowColor = UIColor(hexString: "D5D5D5").cgColor
        self.bgView.layer.shadowOffset = CGSize(width: 0, height: 5)
        self.bgView.layer.shadowOpacity = 0.42
        self.bgView.layer.shadowPath = UIBezierPath(rect: self.bgView.bounds).cgPath
        self.bgView.layer.shadowRadius = 10.0
        bigImageView.roundCorners([.topLeft, .topRight], radius: 10)

        redBottomView.roundCorners([.bottomLeft, .bottomRight], radius: 10)

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
