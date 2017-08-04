//
//  ProjectCollectionViewCell.swift
//  ImpactHub
//
//  Created by Niklas on 19/06/2017.
//  Copyright © 2017 Lightful Ltd. All rights reserved.
//

import UIKit

class GoalCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var bigImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var blurbLabel: UILabel!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        bigImageView.image = nil
    }

    
    func setUp(vm: GoalViewModel) {
        if let phtoUrl = vm.goal.photoUrl {
            bigImageView.kf.setImage(with: phtoUrl)
        }
        nameLabel.text = vm.goal.name
        blurbLabel.text = vm.goal.summary
    }
    
    
    override func draw(_ rect: CGRect) {
        self.bgView.clipsToBounds = false
        self.bgView.layer.shadowColor = UIColor(hexString: "D5D5D5").cgColor
        self.bgView.layer.shadowOffset = CGSize(width: 0, height: 5)
        self.bgView.layer.shadowOpacity = 0.42
        self.bgView.layer.shadowPath = UIBezierPath(rect: self.bgView.bounds).cgPath
        self.bgView.layer.shadowRadius = 10.0

        bigImageView.round(corners:[.topLeft, .topRight], radius: 10)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

    }

    
}
