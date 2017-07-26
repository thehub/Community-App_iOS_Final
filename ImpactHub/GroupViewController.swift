//
//  MemberViewController.swift
//  ImpactHub
//
//  Created by Niklas on 18/05/2017.
//  Copyright © 2017 Lightful Ltd. All rights reserved.
//

import UIKit
import PromiseKit

class GroupViewController: ListFullBleedViewController {

    var group: Group!
    var showPushNotification: PushNotification?
    var posts = [Post]()

    var indexPathToInsertNewPostsAt = IndexPath(item: 2, section: 0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let group = self.group {
            build(group: group)
        }
        else {
            print("ERROR: No group was set?")
        }
        
    }
    
    func build(group: Group) {
        self.title = group.name
        
        super.chatterGroupId = group.chatterId
        
        collectionView.register(UINib.init(nibName: GroupDetailTopViewModel.cellIdentifier, bundle: nil), forCellWithReuseIdentifier: GroupDetailTopViewModel.cellIdentifier)
        collectionView.register(UINib.init(nibName: MemberFeedItemViewModel.cellIdentifier, bundle: nil), forCellWithReuseIdentifier: MemberFeedItemViewModel.cellIdentifier)
        collectionView.register(UINib.init(nibName: TitleViewModel.cellIdentifier, bundle: nil), forCellWithReuseIdentifier: TitleViewModel.cellIdentifier)
        collectionView.register(UINib.init(nibName: GroupViewModel.cellIdentifier, bundle: nil), forCellWithReuseIdentifier: GroupViewModel.cellIdentifier)
        
        data.append(GroupDetailTopViewModel(group: group, cellSize: .zero)) // this will pick the full height instead
        data.append(TitleViewModel(title: "DISCUSSION", cellSize: CGSize(width: view.frame.width, height: 70)))
        // Posts starts from this postion, so when adding new they are inserted here in delegate indexPathToInsertNewPostsAt
        let countBefore = indexPathToInsertNewPostsAt.item
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        firstly {
            APIClient.shared.getGroupPosts(groupID: group.chatterId)
            }.then { posts -> Void in
                self.posts = posts
                posts.forEach({ (post) in
                    self.data.append(MemberFeedItemViewModel(post: post, comment: nil, delegate: self, cellSize: CGSize(width: self.view.frame.width, height: 150)))
                })
            }.always {
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                // Add the new data
                if self.data.count > countBefore {
                    var indexPathsToInsert = [IndexPath]()
                    for i in countBefore...self.data.count - 1 {
                        indexPathsToInsert.append(IndexPath(item: i, section: 0))
                    }
                    self.collectionView.insertItems(at: indexPathsToInsert)
                }
                // If we're showing a push notification, push into respective view from here...
                if let showPushNotification = self.showPushNotification {
                    switch showPushNotification.kind {
                    case .comment(let id, let feedElementId, let chatterGroupId):
                        // Find comment in posts
                        var postToShowCommentsFor: Post?
                        for post in self.posts {
                            if let comment = post.comments.filter({$0.id == id}).first {
                                // We found it
                                postToShowCommentsFor = post
                            }
                        }
                        if postToShowCommentsFor != nil {
                            self.postToShowCommentsFor = postToShowCommentsFor
                            self.performSegue(withIdentifier: "ShowComments", sender: self)
                        }
                        break
                    case .likeComment(let commentId, let chatterGroupId):
                        // Find comment in posts
                        var postToShowCommentsFor: Post?
                        for post in self.posts {
                            if let comment = post.comments.filter({$0.id == commentId}).first {
                                // We found it
                                postToShowCommentsFor = post
                            }
                        }
                        if postToShowCommentsFor != nil {
                            self.postToShowCommentsFor = postToShowCommentsFor
                            self.performSegue(withIdentifier: "ShowComments", sender: self)
                        }
                        break
                    case .likePost(let postId, let chatterGroupId):
                        // TODO: Scroll to the post
                        // Find index path
                        var indexToShow: Int?
                        for (index, vm) in self.data.enumerated() {
                            if let vm = vm as? MemberFeedItemViewModel {
                                if vm.post.id == postId {
                                    indexToShow = index
                                    break
                                }
                            }
                        }
                        if let indexToShow = indexToShow {
                            self.collectionView.scrollToItem(at: IndexPath.init(row: indexToShow, section: 0), at: .top, animated: true)
                        }
                        break
                    default:
                        break
                    }
                }
                
                
            }.catch { error in
                debugPrint(error.localizedDescription)
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if needsToUpdateCommentCount {
            needsToUpdateCommentCount = false
            self.collectionView.reloadData()
        }
    }

    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        super.scrollViewDidScroll(scrollView)
        if let topCell = collectionView.cellForItem(at: IndexPath(item: 0, section: 0)) as? GroupDetailTopCell {
            topCell.didScrollWith(offsetY: scrollView.contentOffset.y)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        
        if let vm = data[indexPath.item] as? MemberFeedItemViewModel {
            let cellWidth: CGFloat = self.collectionView.frame.width
            let height = vm.post.text.height(withConstrainedWidth: cellWidth - 76, font:UIFont(name: "GTWalsheim-Light", size: 14)!) + 85 // add extra height for the standard elements, titles, lines, sapcing etc.
            return CGSize(width: view.frame.width, height: height)
        }
        
        var cellSize = data[indexPath.item].cellSize
        if cellSize == .zero {
            let cellHeight = self.view.frame.height
            cellSize = CGSize(width: view.frame.width, height: cellHeight)
        }
        return cellSize
        
    }
    

    
    var selectMember: Member?
    var selectJob: Job?
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        if let vm = data[indexPath.item] as? MemberViewModel {
//            self.selectMember = vm.member
//            self.performSegue(withIdentifier: "ShowMember", sender: self)
//        }
    }

    
    var needsToUpdateCommentCount = false
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func didCreatePost(post: Post) {
        super.didCreatePost(post: post)
        self.data.insert(MemberFeedItemViewModel(post: post, comment: nil, delegate: self, cellSize: CGSize(width: self.view.frame.width, height: 150)), at: self.indexPathToInsertNewPostsAt.item)
        self.collectionView.insertItems(at: [self.indexPathToInsertNewPostsAt])
        self.collectionView.scrollToItem(at: self.indexPathToInsertNewPostsAt, at: .top, animated: true)
    }
    
    override func didCreateComment(comment: Comment) {
    }
    
    var userIdToShow: String?

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if segue.identifier == "ShowComments" {
            if let vc = segue.destination as? CommentsViewController {
                vc.post = self.postToShowCommentsFor
                vc.commentsViewControllerDelegate = self
            }
        }
        else if segue.identifier == "ShowMember" {
            if let vc = segue.destination as? MemberViewController {
                vc.userId = userIdToShow
            }
        }
    }
}

extension GroupViewController: CommentsViewControllerDelegate {
    func setNeedsToUpdateCommentCount() {
        self.needsToUpdateCommentCount = true
    }
}

extension GroupViewController: MemberFeedItemDelegate {
    func memberFeedWantToShowMember(userId: String) {
        self.userIdToShow = userId
        self.performSegue(withIdentifier: "ShowMember", sender: self)
    }
    
    func memberFeedWantToShowComments(post: Post) {
        self.postToShowCommentsFor = post
        self.performSegue(withIdentifier: "ShowComments", sender: self)
    }
}


