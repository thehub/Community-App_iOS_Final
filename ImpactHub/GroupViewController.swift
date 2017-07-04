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
    
    var indexPathToInsertNewPostsAt = IndexPath(item: 2, section: 0)
    
    var member = Member(id: "sdfds", userId: "sdfsdf", firstName: "Niklas", lastName: "Test", job: "Test", photo: "photo", blurb: "Lorem ipusm", aboutMe: "Lorem ipsum", locationName: "London, UK")

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = group.name
        
        collectionView.register(UINib.init(nibName: GroupDetailTopViewModel.cellIdentifier, bundle: nil), forCellWithReuseIdentifier: GroupDetailTopViewModel.cellIdentifier)
        collectionView.register(UINib.init(nibName: MemberFeedItemViewModel.cellIdentifier, bundle: nil), forCellWithReuseIdentifier: MemberFeedItemViewModel.cellIdentifier)
        collectionView.register(UINib.init(nibName: TitleViewModel.cellIdentifier, bundle: nil), forCellWithReuseIdentifier: TitleViewModel.cellIdentifier)
        collectionView.register(UINib.init(nibName: GroupViewModel.cellIdentifier, bundle: nil), forCellWithReuseIdentifier: GroupViewModel.cellIdentifier)

        topMenu?.hide()
        
        data.append(GroupDetailTopViewModel(group: group, cellSize: .zero)) // this will pick the full height instead
        data.append(TitleViewModel(title: "DISCUSSION", cellSize: CGSize(width: view.frame.width, height: 70)))
        self.collectionView?.reloadData()
        // Posts starts from this postion, so when adding new they are inserted here in delegate indexPathToInsertNewPostsAt
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        firstly {
            APIClient.shared.getGroupPosts(groupID: group.chatterId)
            }.then { posts -> Void in
                print(posts)
                posts.forEach({ (post) in
                    self.data.append(MemberFeedItemViewModel(post: post, member: self.member, comment: nil, delegate: self, cellSize: CGSize(width: self.view.frame.width, height: 150)))
                })
            }.always {
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                self.collectionView?.reloadData()
            }.catch { error in
                debugPrint(error.localizedDescription)
        }
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        
        if let vm = data[indexPath.item] as? MemberFeedItemViewModel {
            let cellWidth: CGFloat = self.collectionView.frame.width
            let height = vm.post.text.height(withConstrainedWidth: cellWidth, font:UIFont(name: "GTWalsheim-Light", size: 12.5)!) + 125 // add extra height for the standard elements, titles, lines, sapcing etc.
            return CGSize(width: view.frame.width, height: height)
        }

        
        var cellSize = data[indexPath.item].cellSize
        if cellSize == .zero {
            let cellHeight = self.view.frame.height
            cellSize = CGSize(width: view.frame.width, height: cellHeight)
        }
        return cellSize
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: self)
        if segue.identifier == "ShowCreatePost" {
            if let navVC = segue.destination as? UINavigationController {
                if let vc = navVC.viewControllers.first as? CreatePostViewController {
                    vc.delegate = self
                    vc.chatterGroupId = self.group.chatterId
                }
            }
        }
        else if segue.identifier == "ShowComments" {
            if let vc = segue.destination as? CommentsViewController, let post = self.postToShowCommentsFor {
                vc.post = post
            }
        }
    }
    
    var selectMember: Member?
    var selectJob: Job?
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        if let vm = data[indexPath.item] as? MemberViewModel {
//            self.selectMember = vm.member
//            self.performSegue(withIdentifier: "ShowMember", sender: self)
//        }
    }

    
    
    var postToShowCommentsFor: Post?
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension GroupViewController: CreatePostViewControllerDelegate {
    func didCreatePost(post: Post) {
        self.data.insert(MemberFeedItemViewModel(post: post, member: self.member, comment: nil, delegate: self, cellSize: CGSize(width: self.view.frame.width, height: 150)), at: self.indexPathToInsertNewPostsAt.item)
        self.collectionView.insertItems(at: [self.indexPathToInsertNewPostsAt])
    }
    
    func didCreateComment(comment: Comment) {
    }
}

extension GroupViewController: MemberFeedItemDelegate {
    func memberFeedWantToShowComments(post: Post) {
        self.postToShowCommentsFor = post
        self.performSegue(withIdentifier: "ShowComments", sender: self)
    }
}


