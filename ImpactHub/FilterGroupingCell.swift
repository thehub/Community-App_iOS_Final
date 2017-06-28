//
//  FilterGroupingCell.swift
//  ImpactHub
//
//  Created by Niklas Alvaeus on 27/06/2017.
//  Copyright © 2017 Lightful Ltd. All rights reserved.
//

import UIKit

class FilterGroupingCell: UICollectionViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var selectedLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func setUp(vm: FilterGroupingViewModel) {
        nameLabel.text = vm.grouping.displayName.uppercased()
        selectedLabel.text = "All"
    }
}
