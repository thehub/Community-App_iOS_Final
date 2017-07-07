//
//  MemberAboutItemCell.swift
//  ImpactHub
//
//  Created by Niklas on 18/05/2017.
//  Copyright © 2017 Lightful Ltd. All rights reserved.
//

import UIKit

class GoalAboutItemCell: UICollectionViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setUp(vm: GoalAboutItemViewModel) {
        titleLabel.text = vm.goal.name
        contentLabel.text = vm.goal.summary
    }
    
}
