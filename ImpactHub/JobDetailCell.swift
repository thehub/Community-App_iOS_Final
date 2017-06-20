//
//  JobDetailCell.swift
//  ImpactHub
//
//  Created by Niklas Alvaeus on 20/06/2017.
//  Copyright © 2017 Lightful Ltd. All rights reserved.
//

import UIKit

class JobDetailCell: UICollectionViewCell {

    @IBOutlet weak var locationNameLabel: UILabel!
    @IBOutlet weak var companySizeLabel: UILabel!
    @IBOutlet weak var payLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setUp(vm: JobDetailViewModel) {

        locationNameLabel.text = vm.job.locationName
        companySizeLabel.text = vm.job.company.size
        payLabel.text = vm.job.salary
        descriptionLabel.text = vm.job.description
        
    }

    
}
