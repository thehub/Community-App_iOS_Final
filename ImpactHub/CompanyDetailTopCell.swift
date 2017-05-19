//
//  MemberDetailTopCell.swift
//  ImpactHub
//
//  Created by Niklas on 18/05/2017.
//  Copyright © 2017 Lightful Ltd. All rights reserved.
//

import UIKit

class CompanyDetailTopCell: UICollectionViewCell {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var jobLabel: UILabel!
    @IBOutlet weak var locationNameLabel: UILabel!
    @IBOutlet weak var blurbLabel: UILabel!
    @IBOutlet weak var facebookImageView: UIImageView!
    @IBOutlet weak var twitterImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        profileImageView.layer.cornerRadius = profileImageView.frame.width/2
        profileImageView.clipsToBounds = true
    }

    var vm:CompanyDetailTopViewModel!
    
    func setup(vm: CompanyDetailTopViewModel) {
        self.vm = vm
        nameLabel.text = vm.company.name
        jobLabel.text = vm.jobDescriptionLong
        profileImageView.image = UIImage(named: vm.company.photo)
        blurbLabel.text = vm.company.blurb
        locationNameLabel.text = vm.locationNameLong
        
    }
    
    @IBAction func visitWebsiteTap(_ sender: Any) {
        let url = URL(string: "http://\(vm.company.website)")!
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
    
}
