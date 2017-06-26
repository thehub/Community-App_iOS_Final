//
//  JobDetailCell.swift
//  ImpactHub
//
//  Created by Niklas Alvaeus on 20/06/2017.
//  Copyright © 2017 Lightful Ltd. All rights reserved.
//

import UIKit


class BigTitleTopCell: UICollectionViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setUp(vm: BigTitleTopViewModel) {
        nameLabel.attributedText = NSAttributedString.init(string: vm.event.name)
    }
    
}
