//
//  JobCollectionViewCell.swift
//  ImpactHub
//
//  Created by Niklas Alvaeus on 19/05/2017.
//  Copyright © 2017 Lightful Ltd. All rights reserved.
//

import UIKit

class JobCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var companyLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var locationNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setUp(vm: JobViewModel) {
        nameLabel.text = vm.job.name
        typeLabel.text = vm.job.type
        companyLabel.text = vm.job.companyName
        locationNameLabel.text = vm.job.locationName
    }

}
