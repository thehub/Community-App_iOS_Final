//
//  MemberViewController.swift
//  ImpactHub
//
//  Created by Niklas on 18/05/2017.
//  Copyright © 2017 Lightful Ltd. All rights reserved.
//

import UIKit
import PromiseKit

class GoalViewController: ListFullBleedViewController {

    var goal: Goal?

    var groups = [Group]()
    var members = [Member]()

    
    var aboutData = [CellRepresentable]()
    var groupsData = [CellRepresentable]()
    var membersData = [CellRepresentable]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = goal?.name
        
        collectionView.register(UINib.init(nibName: GoalDetailTopViewModel.cellIdentifier, bundle: nil), forCellWithReuseIdentifier: GoalDetailTopViewModel.cellIdentifier)
        collectionView.register(UINib.init(nibName: GoalAboutItemViewModel.cellIdentifier, bundle: nil), forCellWithReuseIdentifier: GoalAboutItemViewModel.cellIdentifier)
        collectionView.register(UINib.init(nibName: GoalViewModel.cellIdentifier, bundle: nil), forCellWithReuseIdentifier: GoalViewModel.cellIdentifier)
        collectionView.register(UINib.init(nibName: MemberViewModel.cellIdentifier, bundle: nil), forCellWithReuseIdentifier: MemberViewModel.cellIdentifier)
        collectionView.register(UINib.init(nibName: TitleViewModel.cellIdentifier, bundle: nil), forCellWithReuseIdentifier: TitleViewModel.cellIdentifier)
        collectionView.register(UINib.init(nibName: GroupViewModel.cellIdentifier, bundle: nil), forCellWithReuseIdentifier: GroupViewModel.cellIdentifier)

        
        topMenu?.setupWithItems(["ABOUT", "GROUPS", "MEMBERS"])
        
        guard let goal = self.goal else {
            return
        }
        
        // Feed
        aboutData.append(GoalDetailTopViewModel(goal: goal, cellBackDelegate: self, cellSize: .zero)) // this will pick the full height instead
        aboutData.append(GoalAboutItemViewModel(goal: goal, cellSize: CGSize(width: view.frame.width, height: 0)))
        self.data = aboutData
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        firstly {
            APIClient.shared.getGroups(goalName: goal.name)
            }.then { groups -> Void in
                let filteredItems = groups.filter {$0.groupType == .public || MyGroupsManager.shared.isInGroup(groupId: $0.chatterId)}
                self.groups = filteredItems
            }.then {
                APIClient.shared.getMembers(goalName: goal.name)
            }.then { members -> Void in
                self.members = members
            }.always {
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                self.build()
            }.catch { error in
                debugPrint(error.localizedDescription)
        }
    }
    
    deinit {
        print("\(#file, #function)")
    }
    
    func build() {
        guard let goal = self.goal else {
            return
        }
        
        // Groups
        groupsData.append(GoalDetailTopViewModel(goal: goal, cellBackDelegate: self, cellSize: .zero)) // this will pick the full height instead
        groupsData.append(TitleViewModel(title: "", cellSize: CGSize(width: view.frame.width, height: 40)))
        groups.forEach { (group) in
            groupsData.append(GroupViewModel(group: group, cellSize: CGSize(width: view.frame.width, height: 165)))
        }

        // Members
        membersData.append(GoalDetailTopViewModel(goal: goal, cellBackDelegate: self, cellSize: .zero)) // this will pick the full height instead
        membersData.append(TitleViewModel(title: "", cellSize: CGSize(width: view.frame.width, height: 40)))
        members.forEach { (member) in
            member.contactRequest = ContactRequestManager.shared.getRelevantContactRequestFor(member: member)
            membersData.append(MemberViewModel(member: member, delegate: self, cellSize: CGSize(width: view.frame.width, height: 105)))
        }
    }

    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        super.scrollViewDidScroll(scrollView)
        if let topCell = collectionView.cellForItem(at: IndexPath(item: 0, section: 0)) as? GoalDetailTopCell {
            topCell.didScrollWith(offsetY: scrollView.contentOffset.y)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        
        if let vm = data[indexPath.item] as? GoalAboutItemViewModel {
            let cellWidth: CGFloat = self.collectionView.frame.width - 40
            let text = vm.goal.description ?? ""
            let height = text.height(withConstrainedWidth: cellWidth, font:UIFont(name: "GTWalsheim-Light", size: 12.5)!) + 145 // add extra height for the standard elements, titles, lines, sapcing etc.
            return CGSize(width: view.frame.width, height: height)
        }

        if data[indexPath.item] is ProjectViewModel {
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
    var selectGroup: Group?
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let vm = data[indexPath.item] as? MemberViewModel {
            self.selectMember = vm.member
            self.performSegue(withIdentifier: "ShowMember", sender: self)
        }
        if let vm = data[indexPath.item] as? GroupViewModel {
            self.selectGroup = vm.group
            self.performSegue(withIdentifier: "ShowGroup", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if segue.identifier == "ShowGroup" {
            if let vc = segue.destination as? GroupViewController, let selectGroup = selectGroup {
                vc.group = selectGroup
            }
        }
        else if segue.identifier == "ShowMember" {
            if let vc = segue.destination as? MemberViewController, let selectMember = selectMember {
                vc.member = selectMember
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
    }
    
    override func topMenuDidSelectIndex(_ index: Int) {
        
        self.collectionView.alpha = 0

        if index == 0 {
            self.data = self.aboutData
            self.collectionView.reloadData()
        }
        else if index == 1 {
            self.data = self.groupsData
            self.collectionView.reloadData()
        }
        else if index == 2 {
            self.data = self.membersData
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
        
    }
    
    override func didCreateComment(comment: Comment) {
        
    }
    
    override func didSendContactRequest() {
        self.cellWantsToSendContactRequest?.connectRequestStatus = .outstanding
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension GoalViewController {
    
    override func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        
        guard let indexPath = collectionView.indexPathForItem(at: location) else { return nil }
        guard let cell = collectionView.cellForItem(at: indexPath) else { return nil }
        
        previewingContext.sourceRect = cell.frame
        
        var detailVC: UIViewController!
        
        if let vm = data[indexPath.item] as? GroupViewModel {
            let selectGroup = vm.group
            detailVC = storyboard?.instantiateViewController(withIdentifier: "GroupViewController")
            (detailVC as! GroupViewController).group = selectGroup
            //        detailVC.preferredContentSize = CGSize(width: 0.0, height: 300)
            return detailVC
        }
        if let vm = data[indexPath.item] as? MemberViewModel {
            let selectMember = vm.member
            detailVC = storyboard?.instantiateViewController(withIdentifier: "MemberViewController")
            (detailVC as! MemberViewController).member = selectMember
            //        detailVC.preferredContentSize = CGSize(width: 0.0, height: 300)
            return detailVC
        }
        
        return nil
    }
}

extension GoalViewController: CellBackDelegate {
    func goBack() {
        self.navigationController?.popViewController(animated: true)
    }
}


