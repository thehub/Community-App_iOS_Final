//
//  MemberAboutItemCell.swift
//  ImpactHub
//
//  Created by Niklas on 18/05/2017.
//  Copyright © 2017 Lightful Ltd. All rights reserved.
//

import UIKit

class MemberAboutItemCell: UICollectionViewCell {

    @IBOutlet weak var skillLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setUp(vm: MemberAboutItemViewModel) {
        skillLabel.text = "Skill"
    }
    
}
