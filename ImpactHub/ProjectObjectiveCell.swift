//
//  ProjectObjectiveCell.swift
//  ImpactHub
//
//  Created by Niklas Alvaeus on 20/06/2017.
//  Copyright © 2017 Lightful Ltd. All rights reserved.
//

import UIKit

class ProjectObjectiveCell: UICollectionViewCell {

    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var objectiveTitleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var lineView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func prepareForReuse() {
        lineView.isHidden = false
    }

    func setUp(vm: ProjectObjectiveViewModel) {
        self.numberLabel.text =  String(vm.objective.number)
        self.objectiveTitleLabel.text = vm.objective.title
        self.descriptionLabel.text = vm.objective.description
        if vm.objective.isLast {
            lineView.isHidden = true
        }
        else {
            lineView.isHidden = false
        }
    }

    
}
