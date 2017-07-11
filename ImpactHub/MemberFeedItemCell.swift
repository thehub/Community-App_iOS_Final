//
//  MemberFeedItemCell.swift
//  ImpactHub
//
//  Created by Niklas on 18/05/2017.
//  Copyright © 2017 Lightful Ltd. All rights reserved.
//

import UIKit
import Kingfisher
import PromiseKit

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

    @available(iOS 10.0, *)
    var generatorNotification: UINotificationFeedbackGenerator {
        return UINotificationFeedbackGenerator()
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        profileImageView.layer.cornerRadius = profileImageView.frame.width/2
        profileImageView.clipsToBounds = true
        
        if #available(iOS 10.0, *) {
            generatorNotification.prepare()
        }
    }
    
    var inTransit = false
    
    @IBAction func onTapLike(_ sender: Any) {
        guard let post = vm?.post else {
            return
        }
        if inTransit {
            return
        }
        inTransit = true
        // Are we a comment
        if let comment = vm?.comment {
            if let myLikeId = comment.myLikeId {
                UIApplication.shared.isNetworkActivityIndicatorVisible = true
                firstly {
                    APIClient.shared.unlikeFeedItem(myLikeId: myLikeId)
                    }.then { likeCount -> Void in
                        print(likeCount)
                        self.vm?.comment?.myLikeId = nil
                        if comment.likes > 0 {
                            self.vm?.comment?.likes = comment.likes - 1
                        }
                        if #available(iOS 10.0, *) {
                            self.generatorNotification.notificationOccurred(.success)
                        }
                        self.updateLikes()
                    }.always {
                        self.inTransit = false
                        UIApplication.shared.isNetworkActivityIndicatorVisible = false
                    }.catch { error in
                        debugPrint(error.localizedDescription)
                        if #available(iOS 10.0, *) {
                            self.generatorNotification.notificationOccurred(.error)
                        }
                        let alert = UIAlertController(title: "Error", message: "Could not unlike comment. Please try again.", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                        UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
                }
            }
            else {
                UIApplication.shared.isNetworkActivityIndicatorVisible = true
                firstly {
                    APIClient.shared.likeFeedItem(feedId: comment.id)
                    }.then { myLikeId -> Void in
                        print(myLikeId)
                        self.vm?.comment?.likes = comment.likes + 1
                        self.vm?.comment?.myLikeId = myLikeId
                        if #available(iOS 10.0, *) {
                            self.generatorNotification.notificationOccurred(.success)
                        }
                        self.updateLikes()
                    }.always {
                        self.inTransit = false
                        UIApplication.shared.isNetworkActivityIndicatorVisible = false
                    }.catch { error in
                        debugPrint(error.localizedDescription)
                        if #available(iOS 10.0, *) {
                            self.generatorNotification.notificationOccurred(.error)
                        }
                        let alert = UIAlertController(title: "Error", message: "Could not like comment. Please try again.", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                        UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
                }
            }
        }
        // We are a post
        else {
            if let myLikeId = post.myLikeId {
                UIApplication.shared.isNetworkActivityIndicatorVisible = true
                firstly {
                    APIClient.shared.unlikeFeedItem(myLikeId: myLikeId)
                    }.then { likeCount -> Void in
                        print(likeCount)
                        self.vm?.post.isLikedByCurrentUser = false
                        self.vm?.post.myLikeId = nil
                        if post.likes > 0 {
                            self.vm?.post.likes = post.likes - 1
                        }
                        if #available(iOS 10.0, *) {
                            self.generatorNotification.notificationOccurred(.success)
                        }
                        self.updateLikes()
                    }.always {
                        self.inTransit = false
                        UIApplication.shared.isNetworkActivityIndicatorVisible = false
                    }.catch { error in
                        debugPrint(error.localizedDescription)
                        if #available(iOS 10.0, *) {
                            self.generatorNotification.notificationOccurred(.error)
                        }
                        let alert = UIAlertController(title: "Error", message: "Could not unlike post. Please try again.", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                        UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
                }
            }
            else {
                UIApplication.shared.isNetworkActivityIndicatorVisible = true
                firstly {
                    APIClient.shared.likeFeedItem(feedId: post.id)
                    }.then { myLikeId -> Void in
                        print(myLikeId)
                        self.vm?.post.isLikedByCurrentUser = true
                        self.vm?.post.likes = post.likes + 1
                        self.vm?.post.myLikeId = myLikeId
                        if #available(iOS 10.0, *) {
                            self.generatorNotification.notificationOccurred(.success)
                        }
                        self.updateLikes()
                    }.then {
                        APIClient.shared.sendPush(fromUserId: SessionManager.shared.me?.userId ?? "", toUserIds: post.chatterActor.id, pushType: .likePost(postId: post.id), relatedId: post.id)
                    }.always {
                        self.inTransit = false
                        UIApplication.shared.isNetworkActivityIndicatorVisible = false
                    }.catch { error in
                        debugPrint(error.localizedDescription)
                        if #available(iOS 10.0, *) {
                            self.generatorNotification.notificationOccurred(.error)
                        }
                        let alert = UIAlertController(title: "Error", message: "Could not like post. Please try again.", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                        UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
                }
            }
        }
        
        
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
        }
        else {
            commentView.isHidden = false
            nameLabel.text = vm.post.chatterActor.displayName
            profileImageView.kf.setImage(with: vm.post.chatterActor.profilePicSmallUrl)
            dateLabel.text = MemberFeedItemCell.dateFormatter.string(from: vm.post.date)
            textLabel.text = vm.post.text
            commentCountLabel.text = "\(vm.post.commentsCount)"
        }
        updateLikes()
    }
    
    func updateLikes() {
        if let vm = self.vm {
            // If we're displaying a comment
            if let comment = vm.comment {
                likeCountLabel.text = "\(comment.likes)"
                if comment.isLikedByCurrentUser {
                    likeImageView.tintColor = UIColor.red
                }
                else {
                    likeImageView.tintColor = UIColor.gray
                    
                }
            }
            // If we're displaying a post
            else {
                likeCountLabel.text = "\(vm.post.likes)"
                if vm.post.isLikedByCurrentUser {
                    likeImageView.tintColor = UIColor.red
                }
                else {
                    likeImageView.tintColor = UIColor.gray
                    
                }
            }
        }
        
    }
}
