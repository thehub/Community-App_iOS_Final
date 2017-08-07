//
//  MemberSkillItemCell.swift
//  ImpactHub
//
//  Created by Niklas on 22/05/2017.
//  Copyright © 2017 Lightful Ltd. All rights reserved.
//

import UIKit

class MemberSkillItemCell: UICollectionViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setUp(vm: MemberSkillItemViewModel) {
        titleLabel.text = vm.skill.name
        descriptionLabel.text = vm.skill.description ?? ""
    }

}
