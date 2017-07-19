//
//  MemberViewController.swift
//  ImpactHub
//
//  Created by Niklas on 18/05/2017.
//  Copyright © 2017 Lightful Ltd. All rights reserved.
//

import UIKit
import PromiseKit

class MemberViewController: ListFullBleedViewController {

    var member: Member?
    var memberId: String?
    var projects = [Project]()
    var groups = [Group]()
    
    var memberAboutData = [CellRepresentable]()
    var memberProjectsData = [CellRepresentable]()
    var memberGroupsData = [CellRepresentable]()

    var connectRequestStatus = DMRequest.Satus.notRequested {
        didSet {
            updateConnectButton()
        }
    }
    
    func updateConnectButton() {
        guard let member = self.member else {
            debugPrint("No member set")
            return
        }
        // If we are ourselves, pushed form profile page, hide connect button
        if self.memberId == SessionManager.shared.me?.member.id {
            self.connectContainer?.isHidden = true
            return
        }
        switch connectRequestStatus {
        case .approved:
            connectContainer?.isHidden = false
            connectButton?.setTitle("Contact \(member.name)", for: .normal)
            connectButton?.isHidden = false
            connectButton?.isEnabled = true
            approveDeclineStackView?.isHidden = true
        case .approveDecline:
            connectContainer?.isHidden = false
            connectButton?.isHidden = true
            approveDeclineStackView?.isHidden = false
        case .declined:
            connectContainer?.isHidden = true
        case .outstanding:
            connectContainer?.isHidden = false
            connectButton?.setTitle("Awaiting Response", for: .normal)
            connectButton?.isEnabled = false
            connectButton?.isHidden = false
            approveDeclineStackView?.isHidden = true
        case .notRequested:
            connectContainer?.isHidden = false
            connectButton?.setTitle("Connect with \(member.name)", for: .normal)
            connectButton?.isHidden = false
            connectButton?.isEnabled = true
            approveDeclineStackView?.isHidden = true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.register(UINib.init(nibName: MemberDetailTopViewModel.cellIdentifier, bundle: nil), forCellWithReuseIdentifier: MemberDetailTopViewModel.cellIdentifier)
        collectionView.register(UINib.init(nibName: MemberAboutItemViewModel.cellIdentifier, bundle: nil), forCellWithReuseIdentifier: MemberAboutItemViewModel.cellIdentifier)
        collectionView.register(UINib.init(nibName: MemberSkillItemViewModel.cellIdentifier, bundle: nil), forCellWithReuseIdentifier: MemberSkillItemViewModel.cellIdentifier)
        collectionView.register(UINib.init(nibName: ProjectViewModel.cellIdentifier, bundle: nil), forCellWithReuseIdentifier: ProjectViewModel.cellIdentifier)
        collectionView.register(UINib.init(nibName: GroupViewModel.cellIdentifier, bundle: nil), forCellWithReuseIdentifier: GroupViewModel.cellIdentifier)
        collectionView.register(UINib.init(nibName: TitleViewModel.cellIdentifier, bundle: nil), forCellWithReuseIdentifier: TitleViewModel.cellIdentifier)

        topMenu?.setupWithItems(["ABOUT", "PROJECTS", "GROUPS"])
        
        if let member = self.member {
            buildMember(member)
        }
        // If we're deeplinking in we only have the memberId, so load the member data
        else if let memberId = self.memberId {
            self.connectContainer?.isHidden = true
            loadMember(memberId)
        }
        else {
            debugPrint("Error no member or memberId was set")
        }
        
    }
    
    func loadMember(_ memberId: String) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        firstly {
            APIClient.shared.getMember(contactId: memberId)
            }.then { member -> Void in
                member.contactRequest = ContactRequestManager.shared.getRelevantContactRequestFor(member: member)
                self.member = member
                self.collectionView.reloadData()
                self.buildMember(member)
            }.always {
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            }.catch { error in
                debugPrint(error.localizedDescription)
        }
    }
    
    func buildMember(_ member: Member) {
        
        self.title = member.name
        
        self.connectContainer?.isHidden = false

        self.connectRequestStatus = member.contactRequest?.status ?? .notRequested

        memberAboutData.append(MemberDetailTopViewModel(member: member, cellSize: .zero)) // this will pick the full height instead
        memberAboutData.append(MemberAboutItemViewModel(member: member, cellSize: CGSize(width: view.frame.width, height: 0)))
        self.data = memberAboutData
        let countBefore = self.data.count
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        firstly {
            APIClient.shared.getSkills(contactId: member.id)
            }.then { skills -> Void in
                member.skills = skills
            }.then {
                APIClient.shared.getProjects(contactId: member.id)
            }.then { projects -> Void in
                print(projects)
                self.projects = projects
            }.then {
                APIClient.shared.getGroups(contactId: member.id)
            }.then { groups -> Void in
                self.groups = groups
            }.always {
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                self.buildExtra(member)
                // Add the new data
                var indexPathsToInsert = [IndexPath]()
                for i in countBefore...self.data.count - 1 {
                    indexPathsToInsert.append(IndexPath(item: i, section: 0))
                }
                self.collectionView.insertItems(at: indexPathsToInsert)
                UIView.animate(withDuration: 0.3, delay: 0.1, options: .curveEaseInOut, animations: {
                    self.collectionView?.alpha = 1
                    super.connectButton?.alpha = 1
                }, completion: { (_) in
                    
                })
            }.catch { error in
                debugPrint(error.localizedDescription)
        }
        
    }
    
    func buildExtra(_ member: Member) {
        
        member.skills.forEach { (skill) in
            memberAboutData.append(MemberSkillItemViewModel(skill: skill, cellSize: CGSize(width: view.frame.width, height: 80)))
        }
        self.data = memberAboutData
        
        // Projects
        memberProjectsData.append(MemberDetailTopViewModel(member: member, cellSize: .zero)) // this will pick the full height instead
        projects.forEach { (project) in
            memberProjectsData.append(ProjectViewModel(project: project, cellSize: CGSize(width: view.frame.width, height: 370)))
        }
        
        // Groups
        memberGroupsData.append(MemberDetailTopViewModel(member: member, cellSize: .zero)) // this will pick the full height instead
        groups.forEach { (group) in
            memberGroupsData.append(GroupViewModel(group: group, cellSize: CGSize(width: view.frame.width, height: 165)))
        }

        //        memberGroupsData.append(TitleViewModel(title: "", cellSize: CGSize(width: view.frame.width, height: 40)))

    }
    

    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        super.scrollViewDidScroll(scrollView)
        if let topCell = collectionView.cellForItem(at: IndexPath(item: 0, section: 0)) as? MemberDetailTopCell {
            topCell.didScrollWith(offsetY: scrollView.contentOffset.y)
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        
        if let vm = data[indexPath.item] as? MemberAboutItemViewModel {
            let cellWidth: CGFloat = self.collectionView.frame.width
            let height = vm.member.aboutMe.height(withConstrainedWidth: cellWidth, font:UIFont(name: "GTWalsheim-Light", size: 12.5)!) + 145 // add extra height for the standard elements, titles, lines, sapcing etc.
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
    
    var selectProject: Project?
    var selectGroup: Group?

    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let vm = self.data[indexPath.item] as? ProjectViewModel {
            self.selectProject = vm.project
            self.performSegue(withIdentifier: "ShowProject", sender: self)
        }
        if let vm = self.data[indexPath.item] as? GroupViewModel {
            self.selectGroup = vm.group
            self.performSegue(withIdentifier: "ShowGroup", sender: self)
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowGroup" {
            if let vc = segue.destination as? GroupViewController, let selectGroup = selectGroup {
                vc.group = selectGroup
            }
        }
        if segue.identifier == "ShowProject" {
            if let vc = segue.destination as? ProjectViewController, let selectProject = selectProject {
                vc.project = selectProject
            }
        }
        if segue.identifier == "ShowCreatePost" {
            if let navVC = segue.destination as? UINavigationController {
                if let vc = navVC.viewControllers.first as? CreatePostViewController, let contactId = member?.id {
                    vc.delegate = self
                    vc.createType = .contactRequest(contactId: contactId)
                }
            }
        }
        if segue.identifier == "ShowMessageThread" {
            if let vc = segue.destination as? MessagesThreadViewController, let member = self.member {
                vc.member = member
            }
        }
    }
    
    
    override func topMenuDidSelectIndex(_ index: Int) {
        
        self.collectionView.alpha = 0

        if index == 0 {
            self.data = self.memberAboutData
            self.collectionView.reloadData()
            if connectRequestStatus != .declined {
                showConnectButton()
            }
        }
        else if index == 1 {
            self.data = self.memberProjectsData
            self.collectionView.reloadData()
            hideConnectButton()
        }
        else if index == 2 {
            self.data = self.memberGroupsData
            self.collectionView.reloadData()
            hideConnectButton()
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.collectionView.setContentOffset(CGPoint.init(x: 0, y: self.collectionView.frame.height - 0), animated: false)
            UIView.animate(withDuration: 0.3, delay: 0.1, options: .curveEaseInOut, animations: {
                self.collectionView.alpha = 1
            }, completion: { (_) in
                
            })
        }
    }

    var inTransit = false
    
    @IBAction func connectTap(_ sender: Any) {
        guard self.member != nil else {
            debugPrint("No member set")
            return
        }
        
        if connectRequestStatus == .notRequested {
            self.performSegue(withIdentifier: "ShowCreatePost", sender: self)
        }
        else if connectRequestStatus == .approved {
            self.performSegue(withIdentifier: "ShowMessageThread", sender: self)
        }
    }
    
    @IBAction func approveTap(_ sender: Any) {
        guard let member = self.member else {
            debugPrint("No member set")
            return
        }
        guard let contactRequest = member.contactRequest else {
            print(("Error no member.contactRequest"))
            return
        }
        if inTransit {
            return
        }
        inTransit = true
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        firstly {
            APIClient.shared.updateDMRequest(id: contactRequest.id, status: DMRequest.Satus.approved)
            }.then { result -> Void in
                self.connectRequestStatus = .approved
            }.always {
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                self.inTransit = false
            }.catch { error in
                debugPrint(error.localizedDescription)
                let alert = UIAlertController(title: "Error", message: "Could not approve request. Please try again.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func declineTap(_ sender: Any) {
        guard let member = self.member else {
            debugPrint("No member set")
            return
        }
        guard let contactRequest = member.contactRequest else {
            print(("Error no member.contactRequest"))
            return
        }
        if inTransit {
            return
        }
        inTransit = true
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        firstly {
            APIClient.shared.updateDMRequest(id: contactRequest.id, status: DMRequest.Satus.declined)
            }.then { result -> Void in
                self.connectRequestStatus = .declined
            }.always {
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                self.inTransit = false
            }.catch { error in
                debugPrint(error.localizedDescription)
                let alert = UIAlertController(title: "Error", message: "Could not decline request. Please try again.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
        }
    }
    
    
    override func didCreatePost(post: Post) {
        
    }
    
    override func didCreateComment(comment: Comment) {
        
    }
    
    override func didSendContactRequest() {
        self.connectRequestStatus = .outstanding
    }
    
}




extension MemberViewController {
    
    override func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        
        guard let indexPath = collectionView.indexPathForItem(at: location) else { return nil }
        guard let cell = collectionView.cellForItem(at: indexPath) else { return nil }

        previewingContext.sourceRect = cell.frame

        var detailVC: UIViewController!
        
        if let vm = data[indexPath.item] as? ProjectViewModel {
            let selectProject = vm.project
            detailVC = storyboard?.instantiateViewController(withIdentifier: "ProjectViewController")
            (detailVC as! ProjectViewController).project = selectProject
            //        detailVC.preferredContentSize = CGSize(width: 0.0, height: 300)
            return detailVC
        }
        if let vm = data[indexPath.item] as? GroupViewModel {
            let selectGroup = vm.group
            detailVC = storyboard?.instantiateViewController(withIdentifier: "GroupViewController")
            (detailVC as! GroupViewController).group = selectGroup
            //        detailVC.preferredContentSize = CGSize(width: 0.0, height: 300)
            return detailVC
        }
        
        return nil
    }
}

