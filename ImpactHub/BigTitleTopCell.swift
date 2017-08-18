//
//  JobDetailCell.swift
//  ImpactHub
//
//  Created by Niklas Alvaeus on 20/06/2017.
//  Copyright © 2017 Lightful Ltd. All rights reserved.
//

import UIKit




class BigTitleTopCell: UICollectionViewCell {

    weak var cellBackDelegate: CellBackDelegate?
    
    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setUp(vm: BigTitleTopViewModel) {
        self.cellBackDelegate = vm.cellBackDelegate
        nameLabel.attributedText = NSAttributedString.init(string: vm.event.name)
    }
    
    @IBAction func backTap(_ sender: Any) {
        self.cellBackDelegate?.goBack()
    }
}
