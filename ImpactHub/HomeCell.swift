//
//  HomeCell.swift
//  ImpactHub
//
//  Created by Niklas Alvaeus on 21/07/2017.
//  Copyright © 2017 Lightful Ltd. All rights reserved.
//

import UIKit

class HomeCell: UICollectionViewCell {

    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var titleTextLabel: UILabel!
    @IBOutlet weak var sectionImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setUp(vm: HomeCellViewModel) {
        titleTextLabel.text = vm.section.title
        sectionImageView.image = vm.section.icon
    }
    
    override func draw(_ rect: CGRect) {
        self.bgView.clipsToBounds = false
        self.bgView.layer.shadowColor = UIColor(hexString: "D5D5D5").cgColor
        self.bgView.layer.shadowOffset = CGSize(width: 0, height: 5)
        self.bgView.layer.shadowOpacity = 0.42
        self.bgView.layer.shadowPath = UIBezierPath(rect: self.bgView.bounds).cgPath
        self.bgView.layer.shadowRadius = 10.0
        
    }

}
