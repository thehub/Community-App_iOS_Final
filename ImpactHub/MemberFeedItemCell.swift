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
    func memberFeedWantToShowMember(userId: String)
    func tappedLink(url: URL)
}

class MemberFeedItemCell: UICollectionViewCell, UITextViewDelegate {
    
    @IBOutlet weak var textViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var commentView: UIView!
    @IBOutlet weak var likeContainerView: UIView!
    
    weak var delegate: MemberFeedItemDelegate?
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var textView: UITextView!
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
                    }.then {_ in
                        APIClient.shared.sendPush(fromUserId: SessionManager.shared.me?.member.userId ?? "", toUserIds: post.chatterActor.id, pushType: .likePost(postId: post.id, chatterGroupId: ""), relatedId: post.id)
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

    @IBAction func onTapReport(_ sender: Any) {
        
        let alertController: UIAlertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in
            //cancel code
        }
        let reportAction: UIAlertAction = UIAlertAction(title: "Report Abuse", style: .destructive) { action -> Void in
            self.doReport()
        }
        alertController.addAction(cancelAction)
        alertController.addAction(reportAction)
        
        UIApplication.shared.windows.first?.rootViewController?.present(alertController, animated: true, completion: nil)
    }

    
    func doReport() {
        var idToReport = ""
        var textToReport = ""
        if let id = vm?.post.id {
            idToReport = id
            textToReport = vm?.post.text ?? ""
        }
        else if let id = vm?.comment?.id {
            idToReport = id
            textToReport = vm?.comment?.body ?? ""
        }
        
        firstly {
            APIClient.shared.reportAbuse(fromUserId:SessionManager.shared.me?.member.userId ?? "", message: textToReport)
            }.then { myLikeId -> Void in
                print(myLikeId)
            }.always {
                self.inTransit = false
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                if #available(iOS 10.0, *) {
                    self.generatorNotification.notificationOccurred(.success)
                    let alert = UIAlertController(title: "Reported", message: "Thanks for reporting this post.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                    UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
                }

            }.catch { error in
                debugPrint(error.localizedDescription)
//                if #available(iOS 10.0, *) {
//                    self.generatorNotification.notificationOccurred(.error)
//                }
//                let alert = UIAlertController(title: "Error", message: "Could not send report. Please try again.", preferredStyle: .alert)
//                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
//                UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
        }
        
    }
    
    
    var vm: MemberFeedItemViewModel?
    
    let segmentBuilder = ChatterSegmentBuilder()
    let linkAttributes = [ NSFontAttributeName: UIFont(name: "GTWalsheim-Light", size: 14.0)!, NSForegroundColorAttributeName : UIColor.imaGrapefruit]


    func setUp(vm: MemberFeedItemViewModel) {
        self.vm = vm
        textView.delegate = self
        if let comment = vm.comment {
            commentView.isHidden = true
            likeContainerView.isHidden = true
            nameLabel.text = comment.user?.displayName ?? ""
            if let photoUrl = comment.user?.photo?.smallPhotoUrl {
                profileImageView.kf.setImage(with: photoUrl)
            }
            dateLabel.text = Utils.timeStringFromDate(date: comment.date)
            textView.linkTextAttributes = linkAttributes
            textView.isScrollEnabled = false
            textView.text = vm.comment?.body
            let sizeThatShouldFitTheContent = textView.sizeThatFits(textView.frame.size)
            textViewHeightConstraint.constant = sizeThatShouldFitTheContent.height
        }
        else {
            commentView.isHidden = false
            likeContainerView.isHidden = false
            nameLabel.text = vm.post.chatterActor.displayName
            profileImageView.kf.setImage(with: vm.post.chatterActor.profilePicSmallUrl)
            dateLabel.text = Utils.timeStringFromDate(date: vm.post.date)
            let textToShow = segmentBuilder.attributedTextFromSegments(segments: vm.post.segments)
            textView.linkTextAttributes = linkAttributes
            textView.isScrollEnabled = false
            textView.attributedText = textToShow
            let sizeThatShouldFitTheContent = textView.sizeThatFits(textView.frame.size)
            textViewHeightConstraint.constant = sizeThatShouldFitTheContent.height
            
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
    
    @IBAction func showMemberTap(_ sender: Any) {
        if let comment = vm?.comment {
            if let id = comment.user?.id {
                self.vm?.delegate?.memberFeedWantToShowMember(userId: id)
            }
        }
        else {
            if let id = vm?.post.chatterActor.id {
                self.vm?.delegate?.memberFeedWantToShowMember(userId: id)
            }
        }
    }

    @available(iOS 10.0, *)
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        if URL.absoluteString.contains("x-apple-data-detectors") {
            return true
        }
        else {
            self.vm?.delegate?.tappedLink(url: URL)
            return false
        }
        
    }
    
    @available(iOS 9.0, *)
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange) -> Bool {
        if URL.absoluteString.contains("x-apple-data-detectors") {
            return true
        }
        else {
            self.vm?.delegate?.tappedLink(url: URL)
            return false
        }
    }
    
}
