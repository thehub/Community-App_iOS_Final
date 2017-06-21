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

    func setUp(vm: JobViewModel) {
        companyLabel.text = vm.job.companyName
        nameLabel.text = vm.job.name
        fulltimeLabel.text = vm.job.type
        profileImageView.image = UIImage(named: vm.job.company.photo)
        locationNameLabel.text = vm.job.locationName

    }

    
    override func draw(_ rect: CGRect) {
        self.bgView.clipsToBounds = false
        self.bgView.layer.shadowColor = UIColor(hexString: "D5D5D5").cgColor
        self.bgView.layer.shadowOffset = CGSize(width: 0, height: 5)
        self.bgView.layer.shadowOpacity = 0.42
        self.bgView.layer.shadowPath = UIBezierPath(rect: self.bgView.bounds).cgPath
        self.bgView.layer.shadowRadius = 10.0
        
    }
    
    

}
