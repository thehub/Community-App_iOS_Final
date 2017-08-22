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
    
    override func prepareForReuse() {
        super.prepareForReuse()
        bigImageView.image = nil
    }
    
    func setUp(vm: EventViewModel) {
        
        if let photoUrl = vm.event.photoUrl {
            self.bigImageView.kf.setImage(with: photoUrl)
            self.bigImageView.isHidden = false
            self.fadeView.isHidden = false
            self.gradientLayer.isHidden = false
        }
        else {
            self.bigImageView.isHidden = true
            self.fadeView.isHidden = true
            self.gradientLayer.isHidden = true
        }

        nameLabel.text = vm.event.name
        cityNameLabel.text = vm.event.city
        dateLabel.text = Utils.dateFormatter.string(from: vm.event.date)
        timeLabel.text = Utils.timeFormatter.string(from: vm.event.date)
    }
    
    let gradientLayer: CAGradientLayer = CAGradientLayer()

    
//    override func draw(_ rect: CGRect) {
//        super.draw(rect)
//
//
//    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.bgView.clipsToBounds = false
        self.bgView.layer.shadowColor = UIColor(hexString: "D5D5D5").cgColor
        self.bgView.layer.shadowOffset = CGSize(width: 0, height: 5)
        self.bgView.layer.shadowOpacity = 0.42
        self.bgView.layer.shadowPath = UIBezierPath(rect: self.bgView.bounds).cgPath
        self.bgView.layer.shadowRadius = 10.0
        
        bigImageView.round(corners:[.topLeft, .topRight], radius: 10)
        fadeView.round(corners:[.topLeft, .topRight], radius: 10)
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

    
}
