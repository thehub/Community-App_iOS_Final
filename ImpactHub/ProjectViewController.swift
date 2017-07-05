//
//  MemberViewController.swift
//  ImpactHub
//
//  Created by Niklas on 18/05/2017.
//  Copyright © 2017 Lightful Ltd. All rights reserved.
//

import UIKit
import PromiseKit

class ProjectViewController: ListFullBleedViewController {

    var project: Project!
    
    var indexPathToInsertNewPostsAt = IndexPath(item: 2, section: 0)

    var member = Member(id: "sdfds", userId: "sdfsdf", firstName: "Niklas", lastName: "Test", job: "Test", photo: "photo", blurb: "Lorem ipusm", aboutMe: "Lorem ipsum", locationName: "London, UK")

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
                print(posts)
                posts.forEach({ (post) in
                    self.projectFeedData.append(MemberFeedItemViewModel(post: post, member: self.member, comment: nil, delegate: self, cellSize: CGSize(width: cellWidth, height: 150)))
                })
            }.then {
                APIClient.shared.getMembers(projectId: self.project.id)
            }.then { members -> Void in
                print(members)
                members.forEach({ (member) in
                    let viewModel1 = MemberViewModel(member: member, cellSize: CGSize(width: cellWidth, height: 105))
                    self.projectsMembersData.append(viewModel1)
                })
            }.then {
                APIClient.shared.getObjectives(projectId: self.project.id)
            }.then { objectives -> Void in
                print(objectives)
                self.project.objectives = objectives
                objectives.forEach({ (objective) in
                    self.projectsObjectivesData.append(ProjectObjectiveViewModel(objective: objective, cellSize: CGSize(width: cellWidth, height: 0)))
                })
            }.then {
                APIClient.shared.getJobs(projectId: self.project.id)
            }.then { jobs -> Void in
                print(jobs)
                jobs.forEach({ (job) in
                    let viewModelJob1 = JobViewModel(job: job, cellSize: CGSize(width: cellWidth, height: 145))
                    self.projectsJobsData.append(viewModelJob1)
                })
            }.always {
                self.data = self.projectFeedData
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                self.build()
                self.collectionView?.reloadData()
                self.collectionView?.setContentOffset(CGPoint.init(x: 0, y: -20), animated: false)
                UIView.animate(withDuration: 0.3, delay: 0.1, options: .curveEaseInOut, animations: {
                    self.collectionView?.setContentOffset(CGPoint.init(x: 0, y: 0), animated: false)
                    self.collectionView?.alpha = 1
                    super.connectButton?.alpha = 1
                }, completion: { (_) in
                    
                })
            }.catch { error in
                debugPrint(error.localizedDescription)
        }
        
    }
    
    func build() {
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        
        if let vm = data[indexPath.item] as? MemberFeedItemViewModel {
            let cellWidth: CGFloat = self.collectionView.frame.width
            let height = vm.feedText.height(withConstrainedWidth: cellWidth, font:UIFont(name: "GTWalsheim-Light", size: 12.5)!) + 145 // add extra height for the standard elements, titles, lines, sapcing etc.
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
            if let vc = segue.destination as? MemberViewController, let selectMember = selectMember {
                vc.member = selectMember
            }
        }
        if segue.identifier == "ShowJob" {
            if let vc = segue.destination as? JobViewController, let selectJob = selectJob {
                vc.job = selectJob
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
        self.projectFeedData.insert(MemberFeedItemViewModel(post: post, member: self.member, comment: nil, delegate: self, cellSize: CGSize(width: self.view.frame.width, height: 150)), at: self.indexPathToInsertNewPostsAt.item)
        topMenu?.selectButton(index: 0)
        self.collectionView.scrollToItem(at: self.indexPathToInsertNewPostsAt, at: .top, animated: true)
    }
    
    override func didCreateComment(comment: Comment) {
    }
    
}



extension ProjectViewController: MemberFeedItemDelegate {
    func memberFeedWantToShowComments(post: Post) {
        self.postToShowCommentsFor = post
        self.performSegue(withIdentifier: "ShowComments", sender: self)
    }
}

