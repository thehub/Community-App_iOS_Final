//
//  MemberViewController.swift
//  ImpactHub
//
//  Created by Niklas on 18/05/2017.
//  Copyright © 2017 Lightful Ltd. All rights reserved.
//

import UIKit
import PromiseKit
import SafariServices


class ProjectViewController: ListFullBleedViewController {

    var project: Project!
    var showPushNotification: PushNotification?

    var posts = [Post]()
    
    var indexPathToInsertNewPostsAt = IndexPath(item: 2, section: 0)

    var projectFeedData = [CellRepresentable]()
    var projectsObjectivesData = [CellRepresentable]()
    var projectsMembersData = [CellRepresentable]()
    var projectsJobsData = [CellRepresentable]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = project.name
        
        super.chatterGroupId = project.chatterId

        collectionView.register(UINib.init(nibName: ProjectDetailTopViewModel.cellIdentifier, bundle: nil), forCellWithReuseIdentifier: ProjectDetailTopViewModel.cellIdentifier)
        collectionView.register(UINib.init(nibName: MemberFeedItemViewModel.cellIdentifier, bundle: nil), forCellWithReuseIdentifier: MemberFeedItemViewModel.cellIdentifier)
        collectionView.register(UINib.init(nibName: ProjectViewModel.cellIdentifier, bundle: nil), forCellWithReuseIdentifier: ProjectViewModel.cellIdentifier)
        collectionView.register(UINib.init(nibName: MemberViewModel.cellIdentifier, bundle: nil), forCellWithReuseIdentifier: MemberViewModel.cellIdentifier)
        collectionView.register(UINib.init(nibName: TitleViewModel.cellIdentifier, bundle: nil), forCellWithReuseIdentifier: TitleViewModel.cellIdentifier)
        collectionView.register(UINib.init(nibName: ProjectObjectiveViewModel.cellIdentifier, bundle: nil), forCellWithReuseIdentifier: ProjectObjectiveViewModel.cellIdentifier)
        collectionView.register(UINib.init(nibName: JobViewModel.cellIdentifier, bundle: nil), forCellWithReuseIdentifier: JobViewModel.cellIdentifier)

        topMenu?.setupWithItems(["FEED", "OBJECTIVES", "MEMBERS", "JOBS"])

        // Feed
        projectFeedData.append(ProjectDetailTopViewModel(project: project, cellSize: .zero)) // this will pick the full height instead
        projectFeedData.append(TitleViewModel(title: "DISCUSSIONS", cellSize: CGSize(width: view.frame.width, height: 70)))
        self.data = self.projectFeedData // let it show these items while loading the rest

        // Objectives
        projectsObjectivesData.append(ProjectDetailTopViewModel(project: project, cellSize: .zero)) // this will pick the full height instead
        projectsObjectivesData.append(TitleViewModel(title: "GOALS", cellSize: CGSize(width: view.frame.width, height: 70)))

        // Members
        projectsMembersData.append(ProjectDetailTopViewModel(project: project, cellSize: .zero)) // this will pick the full height instead
        projectsMembersData.append(TitleViewModel(title: "", cellSize: CGSize(width: view.frame.width, height: 70)))

        
        let cellWidth: CGFloat = self.view.frame.width
        
        // Jobs
        projectsJobsData.append(ProjectDetailTopViewModel(project: project, cellSize: .zero)) // this will pick the full height instead
        projectsJobsData.append(TitleViewModel(title: "JOBS FOR THIS PROJECT", cellSize: CGSize(width: view.frame.width, height: 70)))
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        firstly {
            APIClient.shared.getGroupPosts(groupID: self.project.chatterId)
            }.then { posts -> Void in
                self.posts = posts // cache here, so below we can check these if we're coming from a push notification
                posts.forEach({ (post) in
                    self.projectFeedData.append(MemberFeedItemViewModel(post: post, comment: nil, delegate: self, cellSize: CGSize(width: cellWidth, height: 150)))
                })
            }.then {
                APIClient.shared.getMembers(projectId: self.project.id)
            }.then { members -> Void in
                members.forEach({ (member) in
                    member.contactRequest = ContactRequestManager.shared.getRelevantContactRequestFor(member: member)
                    let viewModel1 = MemberViewModel(member: member, delegate: self, cellSize: CGSize(width: cellWidth, height: 105))
                    self.projectsMembersData.append(viewModel1)
                })
            }.then {
                APIClient.shared.getObjectives(projectId: self.project.id)
            }.then { objectives -> Void in
                self.project.objectives = objectives
                objectives.forEach({ (objective) in
                    self.projectsObjectivesData.append(ProjectObjectiveViewModel(objective: objective, cellSize: CGSize(width: cellWidth, height: 0)))
                })
            }.then {
                APIClient.shared.getJobs(projectId: self.project.id)
            }.then { jobs -> Void in
                jobs.forEach({ (job) in
                    let viewModelJob1 = JobViewModel(job: job, cellSize: CGSize(width: cellWidth, height: 145))
                    self.projectsJobsData.append(viewModelJob1)
                })
            }.always {
                self.data = self.projectFeedData
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                // Add the new data
                var indexPathsToInsert = [IndexPath]()
                
                if self.data.count > self.indexPathToInsertNewPostsAt.item {
                    for i in self.indexPathToInsertNewPostsAt.item...self.data.count - 1 {
                        indexPathsToInsert.append(IndexPath(item: i, section: 0))
                    }
                    self.collectionView.insertItems(at: indexPathsToInsert)
                }
                UIView.animate(withDuration: 0.3, delay: 0.1, options: .curveEaseInOut, animations: {
                    self.collectionView?.alpha = 1
                    super.connectButton?.alpha = 1
                }, completion: { (_) in
                    
                    
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
                        case .likeComment(let commentId):
                            print("liked comment")
                        default:
                            break
                        }
                    }

                    
                })
            }.catch { error in
                debugPrint(error.localizedDescription)
        }
    }
    
    deinit {
        print("\(#file, #function)")
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
        if let topCell = collectionView.cellForItem(at: IndexPath(item: 0, section: 0)) as? ProjectDetailTopCell {
            topCell.didScrollWith(offsetY: scrollView.contentOffset.y)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        
        if let vm = data[indexPath.item] as? MemberFeedItemViewModel {
            let cellWidth: CGFloat = self.collectionView.frame.width
            let height = vm.post.text.height(withConstrainedWidth: cellWidth - 76, font:UIFont(name: "GTWalsheim-Light", size: 14)!) + 125 // add extra height for the standard elements, titles, lines, sapcing etc.
            return CGSize(width: view.frame.width, height: height)
        }
        

        if let vm = data[indexPath.item] as? ProjectObjectiveViewModel {
            let cellWidth: CGFloat = self.collectionView.frame.width
            let height = vm.objective.description.height(withConstrainedWidth: cellWidth, font:UIFont(name: "GTWalsheim-Light", size: 12.5)!) + 150 // add extra height for the standard elements, titles, lines, sapcing etc.
            return CGSize(width: view.frame.width, height: height)
        }

        
        
        if let vm = data[indexPath.item] as? ProjectViewModel {
            let cellWidth: CGFloat = self.collectionView.frame.width
            let width = ((cellWidth - 40) / 1.6)
            let heightToUse = width + 155
            return CGSize(width: view.frame.width, height: heightToUse)
        }

        
        
        var cellSize = data[indexPath.item].cellSize
        if cellSize == .zero {
            let cellHeight = self.view.frame.height
            cellSize = CGSize(width: view.frame.width, height: cellHeight)
        }
        return cellSize
        
    }
    
    var selectMember: Member?
    var userIdToShow: String?
    var selectJob: Job?
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let vm = data[indexPath.item] as? MemberViewModel {
            self.selectMember = vm.member
            self.performSegue(withIdentifier: "ShowMember", sender: self)
        }
        else if let vm = data[indexPath.item] as? JobViewModel {
            self.selectJob = vm.job
            self.performSegue(withIdentifier: "ShowJob", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: self)
        if segue.identifier == "ShowMember" {
            if let vc = segue.destination as? MemberViewController {
                vc.member = selectMember
                vc.userId = userIdToShow
            }
        }
        else if segue.identifier == "ShowJob" {
            if let vc = segue.destination as? JobViewController, let selectJob = selectJob {
                vc.job = selectJob
            }
        }
        else if segue.identifier == "ShowCreatePostContactMessage" {
            if let navVC = segue.destination as? UINavigationController {
                if let vc = navVC.viewControllers.first as? CreatePostViewController, let contactId = cellWantsToSendContactRequest?.vm?.member.contactId {
                    vc.delegate = self
                    vc.createType = .contactRequest(contactId: contactId)
                }
            }
        }
        else if segue.identifier == "ShowMessageThread" {
            if let vc = segue.destination as? MessagesThreadViewController, let member = cellWantsToSendContactRequest?.vm?.member {
                vc.member = member
            }
        }
        else if segue.identifier == "ShowComments" {
            if let vc = segue.destination as? CommentsViewController {
                vc.post = self.postToShowCommentsFor
                vc.commentsViewControllerDelegate = self
            }
        }
    }
    
    override func topMenuDidSelectIndex(_ index: Int) {
        
        self.collectionView.alpha = 0

        if index == 0 {
            self.data = self.projectFeedData
            self.collectionView.reloadData()
        }
        else if index == 1 {
            self.data = self.projectsObjectivesData
            self.collectionView.reloadData()
        }
        else if index == 2 {
            self.data = self.projectsMembersData
            self.collectionView.reloadData()
        }
        else if index == 3 {
            self.data = self.projectsJobsData
            self.collectionView.reloadData()
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.collectionView.setContentOffset(CGPoint.init(x: 0, y: self.collectionView.frame.height - 0), animated: false)
            UIView.animate(withDuration: 0.3, delay: 0.1, options: .curveEaseInOut, animations: {
                self.collectionView.alpha = 1
            }, completion: { (_) in
                
            })
        }
    }

    


    override func didCreatePost(post: Post) {
        super.didCreatePost(post: post)
        self.projectFeedData.insert(MemberFeedItemViewModel(post: post, comment: nil, delegate: self, cellSize: CGSize(width: self.view.frame.width, height: 150)), at: self.indexPathToInsertNewPostsAt.item)
        topMenu?.selectButton(index: 0)
        self.collectionView.scrollToItem(at: self.indexPathToInsertNewPostsAt, at: .top, animated: true)
    }
    
    override func didCreateComment(comment: Comment) {
    }
 
    override func didSendContactRequest() {
        self.cellWantsToSendContactRequest?.connectRequestStatus = .outstanding
    }
    
    
    var needsToUpdateCommentCount = false

}

extension ProjectViewController: CommentsViewControllerDelegate {
    func setNeedsToUpdateCommentCount() {
        self.needsToUpdateCommentCount = true
    }
}

extension ProjectViewController: MemberFeedItemDelegate {
    func memberFeedWantToShowMember(userId: String) {
        self.userIdToShow = userId
        self.performSegue(withIdentifier: "ShowMember", sender: self)
    }
    
    func memberFeedWantToShowComments(post: Post) {
        self.postToShowCommentsFor = post
        self.performSegue(withIdentifier: "ShowComments", sender: self)
    }
    
    func tappedLink(url: URL) {
        // Get the id out, then get that record from the item.segment to check what to link to
        if url.scheme == "mention" {
            let mentionId = url.absoluteString.replacingOccurrences(of: "mention://", with: "")
            // TODO: Implement mentions here
            //            if let segment = self.item?.segments.filter({$0 is Mention }).first as? Mention {
            //                if segment.record["id"].string == mentionId {
            //                    if segment.record["type"].string == "User" {
            //                        let userId = segment.record["id"].stringValue
            //                        print(userId)
            //                        self.userIdToShow = userId
            //                        self.performSegue(withIdentifier: "ShowAuthor", sender: self)
            //                    }
            //                    else if segment.record["type"].string == "CollaborationGroup" {
            //                        let groupId = segment.record["id"].stringValue
            //                        self.groupIdToShow = groupId
            //                        self.performSegue(withIdentifier: "ShowGroup", sender: self)
            //                    }
            //                }
            //            }
        }
        else {
            let svc = SFSafariViewController(url: url)
            self.present(svc, animated: true, completion: nil)
        }
    }
}

