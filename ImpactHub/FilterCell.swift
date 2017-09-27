//
//  FilterGroupingCell.swift
//  ImpactHub
//
//  Created by Niklas Alvaeus on 27/06/2017.
//  Copyright © 2017 Lightful Ltd. All rights reserved.
//

import UIKit

class FilterCell: UICollectionViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var selectionImageView: UIImageView!
    @IBOutlet weak var selectedDotImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectedDotImageView.transform = CGAffineTransform.init(scaleX: 0.0, y: 0.0)
    }

    override func prepareForReuse() {
        self.selectedDotImageView.transform = CGAffineTransform.init(scaleX: 0.0, y: 0.0)
    }
    
    func setUp(vm: FilterViewModel) {
    
//        if vm.filter.grouping == .hub {
//            nameLabel.text = SessionManager.shared.hubs.first?.name  // TODO: Map this id to the hub names
//        }
//        else {
            nameLabel.text = vm.filter.name.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
//        }
    }
    
    
    override var isSelected: Bool {
        get {
            return super.isSelected
        }
        set {
            if newValue {
                super.isSelected = true
                UIView.animate(withDuration: 0.1, delay: 0.0, options: .curveEaseInOut, animations: {
                    self.selectedDotImageView.transform = CGAffineTransform.identity
                }, completion: { (_) in
                })
            } else if newValue == false {
                super.isSelected = false
                UIView.animate(withDuration: 0.1, delay: 0.0, options: .curveEaseInOut, animations: {
                    self.selectedDotImageView.transform = CGAffineTransform.init(scaleX: 0.01, y: 0.01)
                }, completion: { (_) in
                })
            }
        }
    }
    
    
}
