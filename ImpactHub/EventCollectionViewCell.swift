//
//  ProjectCollectionViewCell.swift
//  ImpactHub
//
//  Created by Niklas on 19/06/2017.
//  Copyright © 2017 Lightful Ltd. All rights reserved.
//

import UIKit

class EventCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var bigImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!

    
    @IBOutlet weak var fadeView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func setUp(vm: EventViewModel) {
        bigImageView.image = UIImage(named: vm.event.photo)
        nameLabel.text = vm.event.name
        cityNameLabel.text = vm.event.locationName
        dateLabel.text = "15 May"  //vm.event.date // TODO:
        timeLabel.text = "2pm - 5pm" // TODO:
    }
    
    let gradientLayer: CAGradientLayer = CAGradientLayer()

    
    override func draw(_ rect: CGRect) {
        self.bgView.clipsToBounds = false
        self.bgView.layer.shadowColor = UIColor(hexString: "D5D5D5").cgColor
        self.bgView.layer.shadowOffset = CGSize(width: 0, height: 5)
        self.bgView.layer.shadowOpacity = 0.42
        self.bgView.layer.shadowPath = UIBezierPath(rect: self.bgView.bounds).cgPath
        self.bgView.layer.shadowRadius = 10.0

        bigImageView.roundCorners([.topLeft, .topRight], radius: 10)

    
        fadeView.layer.cornerRadius = 10
        fadeView.clipsToBounds = true
        
        gradientLayer.removeFromSuperlayer()
        let startingColorOfGradient = UIColor(hexString: "252424").withAlphaComponent(0.0).cgColor
        let midColor = UIColor(hexString: "181818").withAlphaComponent(0.66).cgColor
        let endingColorOFGradient = UIColor(hexString: "252424").withAlphaComponent(1.0).cgColor
        gradientLayer.frame = self.fadeView.layer.bounds
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y:1.0)
        gradientLayer.locations = [NSNumber.init(value: 0.0), NSNumber.init(value: 0.8), NSNumber.init(value: 1.0)]
        gradientLayer.colors = [startingColorOfGradient, midColor, endingColorOFGradient]
        fadeView.layer.insertSublayer(gradientLayer, at: 0)
    
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

    }

    
}
