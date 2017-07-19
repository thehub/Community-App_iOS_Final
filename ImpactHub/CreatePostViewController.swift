//
//  CreatePostViewController.swift
//  ImpactHub
//
//  Created by Niklas on 03/07/2017.
//  Copyright © 2017 Lightful Ltd. All rights reserved.
//

import UIKit
import PromiseKit


protocol CreatePostViewControllerDelegate: class {
    func didCreatePost(post: Post)
    func didCreateComment(comment: Comment)
    func didSendContactRequest()
}

class CreatePostViewController: UIViewController, UITextViewDelegate {

    weak var delegate: CreatePostViewControllerDelegate?

    enum CreateType {
        case post(chatterGroupId: String)
        case comment(postIdToCommentOn: String, toUserId:String)
        case applyForJob(jobId: String)
        case contactRequest(contactId: String)
        case unkown
    }
    
    var createType: CreateType = .unkown
    
    var inTransit = false
    var mentionCompletions = [MentionCompletion]()
    let segmentBuilder = ChatterSegmentBuilder()

    @IBOutlet weak var textView: UITextView!
    
    @available(iOS 10.0, *)
    var generatorNotification: UINotificationFeedbackGenerator {
        return UINotificationFeedbackGenerator()
    }
    
    @available(iOS 10.0, *)
    var generatorFeedback: UISelectionFeedbackGenerator {
        return UISelectionFeedbackGenerator()
    }
    
    @available(iOS 10.0, *)
    var generatorImpact: UIImpactFeedbackGenerator {
        return UIImpactFeedbackGenerator(style: .medium)
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 10.0, *) {
            self.generatorImpact.impactOccurred()
        }

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if #available(iOS 10.0, *) {
            generatorNotification.prepare()
            generatorFeedback.prepare()
            generatorImpact.prepare()
        }
        
        switch createType {
        case .post:
            self.title = "Create Post"
            break
        case .comment(postIdToCommentOn: _):
            self.title = "Add Comment"
            break
        case .applyForJob(jobId: _):
            self.title = "Apply For Job"
            break
        case .contactRequest(contactId: _):
            self.title = "Introduction Message"
        case .unkown:
            print("Error createType not set")
            break
        }
        
        switch self.createType {
            case .post(let chatterGroupId):
                UIApplication.shared.isNetworkActivityIndicatorVisible = true
                firstly {
                    APIClient.shared.getMentionCompletions()
                    }.then { items in
                        APIClient.shared.getMentionValidations(parentId: chatterGroupId, mentionCompletions: items)
                    }.then { validItems -> Void in
                        print(validItems)
                        self.mentionCompletions = validItems
                    }.always {
                        UIApplication.shared.isNetworkActivityIndicatorVisible = false
                    }.catch { error in
                        debugPrint(error.localizedDescription)
                }
                //            APIClient.shared.getValidMentionCompletions(parentId: parentId).then { result in
                //                self.mentionCompletions = result
                //                }.catch { error in
                //                    debugPrint(error.localizedDescription)
                //            }
            break
            default:
            break
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.textView.becomeFirstResponder()
    }
    
    @IBAction func onClose(_ sender: Any) {
        textView.delegate = nil
        self.dismiss(animated: true) {
            
        }
    }

    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        if let text = textView.text {
            sendPost(text: text)
        }
        else {
            onClose(self)
        }
        return true
    }
    
    var currentImagePicked: Data?
    
    func sendPost(text: String) {
        guard let text = self.textView.text else {
            onClose(self)
            return
        }
        
        if self.inTransit {
            return
        }
        
        if self.textView.text.characters.count > 0 {
            self.inTransit = true
            if let currentImagePicked = self.currentImagePicked {
//                APIClient.shared.uploadImage(imageData: currentImagePicked, completion: { (result) in
//                    switch result {
//                    case .Success(let id):
//                        let segments = self.segmentBuilder.buildSegmentsFrom(text: self.textView.text!, mentionCompletions: self.mentionCompletions)
//                        APIClient.shared.postToGroup(groupID: self.groupId!, messageSegments: segments, fileId: id, completion: { (result) in
//                            self.inTransit = false
//                            switch result {
//                            case .Success(let item):
//                                self.delegate?.didAddNewsItem(news: item)
//                                self.presentingViewController?.dismiss(animated: true, completion: {
//                                    
//                                })
//                                break
//                            case .Failure( _):
//                                let alert = UIAlertController(title: "Error", message: "Could not create post. Please try again.", preferredStyle: .alert)
//                                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
//                                self.present(alert, animated: true, completion: nil)
//                                break
//                            }
//                        })
//                        break
//                    case .Failure( _):
//                        let alert = UIAlertController(title: "Error", message: "Could not create post. Please try again.", preferredStyle: .alert)
//                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
//                        self.present(alert, animated: true, completion: nil)
//                        break
//                    }
//                    
//                })
            }
            else {
                UIApplication.shared.isNetworkActivityIndicatorVisible = true
                let segments = self.segmentBuilder.buildSegmentsFrom(text: text, mentionCompletions: self.mentionCompletions)

                // Create Comment
                switch createType {
                case .comment(let postIdToCommentOn, let toUserId):
                    firstly {
                        APIClient.shared.postComment(newsID: postIdToCommentOn, message: text)
                        }.then { comment -> Void in
                            if #available(iOS 10.0, *) {
                                self.generatorNotification.notificationOccurred(.success)
                            }
                            self.delegate?.didCreateComment(comment: comment)
                        }.then {_ in
                            APIClient.shared.sendPush(fromUserId: SessionManager.shared.me?.member.userId ?? "", toUserIds: toUserId, pushType: .comment(id: postIdToCommentOn, feedElementId: postIdToCommentOn), relatedId: postIdToCommentOn)
                        }.then {_ in
                            self.onClose(self)
                        }.always {
                            self.inTransit = false
                            UIApplication.shared.isNetworkActivityIndicatorVisible = false
                        }.catch { error in
                            debugPrint(error.localizedDescription)
                            if #available(iOS 10.0, *) {
                                self.generatorNotification.notificationOccurred(.error)
                            }
                            let alert = UIAlertController(title: "Error", message: "Could not add comment. Please try again.", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                            self.present(alert, animated: true, completion: nil)
                    }
                    break
                case .post(let chatterGroupId):
                    firstly {
                        APIClient.shared.postToGroup(groupID: chatterGroupId, messageSegments: segments, fileId: nil)
                        }.then { post -> Void in
                            if #available(iOS 10.0, *) {
                                self.generatorNotification.notificationOccurred(.success)
                            }
                            self.delegate?.didCreatePost(post: post)
                            self.onClose(self)
                        }.always {
                            self.inTransit = false
                            UIApplication.shared.isNetworkActivityIndicatorVisible = false
                        }.catch { error in
                            debugPrint(error.localizedDescription)
                            if #available(iOS 10.0, *) {
                                self.generatorNotification.notificationOccurred(.error)
                            }
                            let alert = UIAlertController(title: "Error", message: "Could not create post. Please try again.", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                            self.present(alert, animated: true, completion: nil)
                    }
                    break
                case .applyForJob(let jobId):
                    print(jobId)
                    self.onClose(self)
                    break
                case .contactRequest(let contactId):
                    firstly {
                        APIClient.shared.createDMRequest(fromContactId: SessionManager.shared.me?.member.id ?? "", toContactId: contactId, message: self.textView.text)
                        }.then { result -> Void in
                            if #available(iOS 10.0, *) {
                                self.generatorNotification.notificationOccurred(.success)
                            }
                            self.delegate?.didSendContactRequest()
                            self.onClose(self)
                        }.always {
                            UIApplication.shared.isNetworkActivityIndicatorVisible = false
                            self.inTransit = false
                        }.catch { error in
                            debugPrint(error.localizedDescription)
                            let alert = UIAlertController(title: "Error", message: "Could not send request. Please try again.", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                            self.present(alert, animated: true, completion: nil)
                    }
                case .unkown:
                    print("Error createType not set")
                    break
                }
                

            }
        }
    
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
    }
    
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        guard let oldText = textView.text else { return true }
        
        if text == "\n" {
            textView.resignFirstResponder()
//            if textView.text.characters.count == 0 {
//                resetTextField()
//            }
            return false
        }
        
        let newLength = oldText.utf16.count + text.utf16.count - range.length
        
        switch createType {
        case .contactRequest(contactId: _):
            return newLength <= 254
        default:
            return newLength <= 5000
        }
        
        
    }

}
