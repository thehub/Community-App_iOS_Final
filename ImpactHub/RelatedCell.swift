//
//  JobDetailCell.swift
//  ImpactHub
//
//  Created by Niklas Alvaeus on 20/06/2017.
//  Copyright © 2017 Lightful Ltd. All rights reserved.
//

import UIKit
import Kingfisher

class RelatedCell: UICollectionViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var profileImageShadowView: UIView!
    @IBOutlet weak var companyLabel: UILabel!
    @IBOutlet weak var viewButton: UIButton!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setUp(vm: RelatedViewModel) {

        
        
        if let job = vm.job {
            nameLabel.text = job.name
            companyLabel.text = job.company.name
            
            if let logoUrl = job.company.logoUrl {
                profileImageView.kf.setImage(with: logoUrl)
            }

            viewButton.setTitle("View Job", for: .normal)
            viewButton.setTitle("View Job", for: .highlighted)
        }
        else if let project = vm.project {
            nameLabel.text = project.name
            companyLabel.text = "[TODO]" //job.company.name
            if let photoUrl = project.photoUrl {
                profileImageView.kf.setImage(with: photoUrl)
            }
            viewButton.setTitle("View Project", for: .normal)
            viewButton.setTitle("View Project", for: .highlighted)
        }
        
        
    }

    override func draw(_ rect: CGRect) {
        
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
    
}
