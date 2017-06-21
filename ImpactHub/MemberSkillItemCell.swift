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
        titleLabel.text = "Skill" // TODO: get this from service
        descriptionLabel.text = "Lorem ipusm dolores set etium non consig detum do et set etium non consig detum do et."
    }

}
