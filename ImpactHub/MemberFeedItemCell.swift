//
//  MemberFeedItemCell.swift
//  ImpactHub
//
//  Created by Niklas on 18/05/2017.
//  Copyright © 2017 Lightful Ltd. All rights reserved.
//

import UIKit
import Kingfisher

class MemberFeedItemCell: UICollectionViewCell {
    
    static var dateFormatter: DateFormatter {
        get {
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            formatter.timeStyle = .short
            return formatter
        }
    }

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var likeImageView: UIImageView!
    @IBOutlet weak var likeCountLabel: UILabel!
    @IBOutlet weak var commentImageView: UIImageView!
    @IBOutlet weak var commentCountLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        profileImageView.layer.cornerRadius = profileImageView.frame.width/2
        profileImageView.clipsToBounds = true
    }
    
    @IBAction func onTapLike(_ sender: Any) {
    }
    
    @IBAction func onTapComment(_ sender: Any) {
    }

    func setUp(vm: MemberFeedItemViewModel) {
        nameLabel.text = vm.post.chatterActor.displayName
//        print(vm.post.chatterActor.profilePicSmallUrl)
        profileImageView.kf.setImage(with: vm.post.chatterActor.profilePicSmallUrl)
        dateLabel.text = MemberFeedItemCell.dateFormatter.string(from: vm.post.date)
        textLabel.text = vm.post.text
        likeCountLabel.text = "\(vm.post.likes)"
        commentCountLabel.text = "\(vm.post.commentsCount)"
    }
}
