//
//  CommentsViewController.swift
//  ImpactHub
//
//  Created by Niklas on 03/07/2017.
//  Copyright © 2017 Lightful Ltd. All rights reserved.
//

import UIKit
import PromiseKit


protocol CommentsViewControllerDelegate: class {
    func setNeedsToUpdateCommentCount()
}

class CommentsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!

    var post: Post?
    
    var data = [CellRepresentable]()
    
    weak var commentsViewControllerDelegate: CommentsViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Comments"
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
        
        collectionView.register(UINib.init(nibName: MemberFeedItemViewModel.cellIdentifier, bundle: nil), forCellWithReuseIdentifier: MemberFeedItemViewModel.cellIdentifier)

        if let post = post {
            post.comments.forEach({ (comment) in
                self.data.append(MemberFeedItemViewModel(post: post, comment: comment, delegate: self, cellSize: CGSize(width: self.view.frame.width, height: 150)))
            })

            // Are there more comments to load
            if let commentsNextPageUrl = post.commentsNextPageUrl {
                UIApplication.shared.isNetworkActivityIndicatorVisible = true
                firstly {
                    APIClient.shared.loadComments(nextPageUrl: commentsNextPageUrl)
                    }.then { comments -> Void in
                        comments.forEach({ (comment) in
                            self.data.append(MemberFeedItemViewModel(post: post, comment: comment, delegate: self, cellSize: CGSize(width: self.view.frame.width, height: 150)))
                            // TODO: Load more here if still more available
                        })
                    }.always {
                        UIApplication.shared.isNetworkActivityIndicatorVisible = false
                        self.collectionView?.reloadData()
                    }.catch { error in
                        debugPrint(error.localizedDescription)
                }
            }
        }
        
        
    }
    

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // If no comments show create comment
        if post?.comments.isEmpty ?? false {
            self.performSegue(withIdentifier: "ShowCreateComment", sender: self)
        }

    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        
        if let vm = data[indexPath.item] as? MemberFeedItemViewModel, let comment = vm.comment {
            let cellWidth: CGFloat = self.collectionView.frame.width
            let height = comment.body.height(withConstrainedWidth: cellWidth - 76, font:UIFont(name: "GTWalsheim-Light", size: 14)!) + 85 // add extra height for the standard elements, titles, lines, sapcing etc.
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
    
    
    
    var postIdToCommentOn: String?
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: self)
        if segue.identifier == "ShowCreateComment" {
            if let navVC = segue.destination as? UINavigationController {
                if let vc = navVC.viewControllers.first as? CreatePostViewController, let postId = self.post?.id {
                    vc.delegate = self
                    vc.createType = .comment(postIdToCommentOn: postId)
                }
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension CommentsViewController: MemberFeedItemDelegate {
    func memberFeedWantToShowComments(post: Post) {
        // do nothing
    }
}

extension CommentsViewController: CreatePostViewControllerDelegate {
    func didCreatePost(post: Post) {
        
    }
    
    func didCreateComment(comment: Comment) {
        if let post = self.post {
            self.data.insert(MemberFeedItemViewModel(post: post, comment: comment, delegate: self, cellSize: CGSize(width: self.view.frame.width, height: 150)), at: 0)
            self.collectionView.insertItems(at: [IndexPath.init(row: 0, section: 0)])
            self.collectionView.scrollToItem(at: IndexPath.init(row: 0, section: 0), at: .top, animated: true)
            self.post?.commentsCount += 1
            self.commentsViewControllerDelegate?.setNeedsToUpdateCommentCount()
        }
        else {
            print("Error did not have a post on CommentsViewController")
        }
    }
}


extension CommentsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = data[indexPath.item].cellInstance(collectionView, indexPath: indexPath)
        return cell
    }
}





