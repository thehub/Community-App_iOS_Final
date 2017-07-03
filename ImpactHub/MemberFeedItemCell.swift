//
//  MemberFeedItemCell.swift
//  ImpactHub
//
//  Created by Niklas on 18/05/2017.
//  Copyright © 2017 Lightful Ltd. All rights reserved.
//

import UIKit
import Kingfisher

protocol MemberFeedItemDelegate: class {
    func memberFeedWantToShowComments(post: Post)
}

class MemberFeedItemCell: UICollectionViewCell {
    
    @IBOutlet weak var commentView: UIView!
    @IBOutlet weak var likeContainerView: UIView!
    
    weak var delegate: MemberFeedItemDelegate?
    
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
        guard let vm = self.vm else {
            return
        }
        self.vm?.delegate?.memberFeedWantToShowComments(post: vm.post)
    }

    var vm: MemberFeedItemViewModel?
    
    func setUp(vm: MemberFeedItemViewModel) {
        self.vm = vm
        if let comment = vm.comment {
            commentView.isHidden = true
            nameLabel.text = comment.user?.displayName ?? ""
            if let photoUrl = comment.user?.photo?.smallPhotoUrl {
                profileImageView.kf.setImage(with: photoUrl)
            }
            dateLabel.text = MemberFeedItemCell.dateFormatter.string(from: comment.date)
            textLabel.text = vm.comment?.body
            likeCountLabel.text = "\(comment.likes)"
        }
        else {
            commentView.isHidden = false
            nameLabel.text = vm.post.chatterActor.displayName
            profileImageView.kf.setImage(with: vm.post.chatterActor.profilePicSmallUrl)
            dateLabel.text = MemberFeedItemCell.dateFormatter.string(from: vm.post.date)
            textLabel.text = vm.post.text
            likeCountLabel.text = "\(vm.post.likes)"
            commentCountLabel.text = "\(vm.post.commentsCount)"
        }
    }
}
