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


class CompanyViewController: ListFullBleedViewController {

    var company: Company?
    var compnayId: String?
    
    var projects = [Project]()
    var members = [Member]()

    var aboutData = [CellRepresentable]()
    var projectsData = [CellRepresentable]()
    var membersData = [CellRepresentable]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.register(UINib.init(nibName: CompanyDetailTopViewModel.cellIdentifier, bundle: nil), forCellWithReuseIdentifier: CompanyDetailTopViewModel.cellIdentifier)
        collectionView.register(UINib.init(nibName: CompanyAboutViewModel.cellIdentifier, bundle: nil), forCellWithReuseIdentifier: CompanyAboutViewModel.cellIdentifier)
        collectionView.register(UINib.init(nibName: TitleViewModel.cellIdentifier, bundle: nil), forCellWithReuseIdentifier: TitleViewModel.cellIdentifier)
        collectionView.register(UINib.init(nibName: ProjectViewModel.cellIdentifier, bundle: nil), forCellWithReuseIdentifier: ProjectViewModel.cellIdentifier)
        collectionView.register(UINib.init(nibName: MemberViewModel.cellIdentifier, bundle: nil), forCellWithReuseIdentifier: MemberViewModel.cellIdentifier)
        collectionView.register(UINib.init(nibName: CompanyServiceItemViewModel.cellIdentifier, bundle: nil), forCellWithReuseIdentifier: CompanyServiceItemViewModel.cellIdentifier)
        
        if self.company != nil {
            buildCompany()
            getCompanyExtras()
        }
        else if let companyId = self.compnayId {
            self.collectionView?.alpha = 0
            super.connectButton?.alpha = 0
            // Load in company
            UIApplication.shared.isNetworkActivityIndicatorVisible = true

            firstly {
                ContactRequestManager.shared.refresh()
                }.then { contactRequests -> Void in
                    print("refreshed")
                }.then {
                    APIClient.shared.getCompany(companyId: companyId)
                }.then { item -> Void in
                    self.company = item
                    self.buildCompany()
                    self.getCompanyExtras()
                }
                .always {
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                }.catch { error in
                    debugPrint(error.localizedDescription)
            }
        }
        else {
            debugPrint("No Company or companyId")
        }
        
    }
    
    deinit {
        print("\(#file, #function)")
    }
    
    func getCompanyExtras() {
        guard let company = self.company else {
            print("ERROR: no compnay set")
            return
        }
        

        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        firstly {
            ContactRequestManager.shared.refresh()
            }.then { contactRequests -> Void in
                print("refreshed")
            }.then {
                APIClient.shared.getCompanyServices(companyId: company.id)
            }.then { services -> Void in
                self.company!.services = services
            }.then {
                APIClient.shared.getProjects(companyId: company.id)
            }.then { projects -> Void in
                let filteredItems = projects.filter {$0.groupType == .public || MyGroupsManager.shared.isInGroup(groupId: $0.chatterId)}
                self.projects = filteredItems
            }.then {
                APIClient.shared.getMembers(companyId: company.id)
            }.then { members -> Void in
                self.members = members
            }.always {
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                self.buildExtras()
                UIView.animate(withDuration: 0.3, delay: 0.1, options: .curveEaseInOut, animations: {
                    self.collectionView?.alpha = 1
                    super.connectButton?.alpha = 1
                }, completion: { (_) in
                    
                })
            }.catch { error in
                debugPrint(error.localizedDescription)
        }
    }
    
    func buildCompany() {
        guard let company = self.company else {
            return
        }
        
        if company.website != nil {
            connectButton?.setTitle("Visit Website", for: .normal)
        }
        else {
            connectButton?.isHidden = true
        }
        
        self.title = company.name
        
        topMenu?.setupWithItems(["About", "Projects", "Members"])
        
        // About
        aboutData.append(CompanyDetailTopViewModel(company: company, cellBackDelegate: self, cellSize: .zero)) // this will pick the full height instead
        aboutData.append(TitleViewModel(title: "ABOUT", cellSize: CGSize(width: view.frame.width, height: 60)))
        aboutData.append(CompanyAboutViewModel(company: company, cellSize: CGSize(width: view.frame.width, height: 0)))

        self.data = aboutData

    }
    
    func buildExtras() {
        guard let company = self.company else {
            return
        }
        
        let countBefore = self.data.count
        // Services
        aboutData.append(TitleViewModel(title: "OUR SERVICES", cellSize: CGSize(width: view.frame.width, height: 50)))
        company.services.forEach { (service) in
            aboutData.append(CompanyServiceItemViewModel(service: service, cellSize: CGSize(width: view.frame.width, height: 0)))
        }
        self.data = aboutData
        
        // Projects
        projectsData.append(CompanyDetailTopViewModel(company: company, cellBackDelegate: self, cellSize: .zero)) // this will pick the full height instead
        projects.forEach { (project) in
            projectsData.append(ProjectViewModel(project: project, cellSize: CGSize(width: view.frame.width, height: 370)))
        }
        
        // Members
        membersData.append(CompanyDetailTopViewModel(company: company, cellBackDelegate: self, cellSize: .zero)) // this will pick the full height instead
        membersData.append(TitleViewModel(title: "", cellSize: CGSize(width: view.frame.width, height: 70)))
        members.forEach { (member) in
            member.contactRequest = ContactRequestManager.shared.getRelevantContactRequestFor(member: member)
            membersData.append(MemberViewModel(member: member, delegate:self, cellSize: CGSize(width: view.frame.width, height: 105)))
        }
        
        // Add the new data
        if self.data.count > countBefore {
            var indexPathsToInsert = [IndexPath]()
            for i in countBefore...self.data.count - 1 {
                indexPathsToInsert.append(IndexPath(item: i, section: 0))
            }
            self.collectionView.insertItems(at: indexPathsToInsert)
        }
        
    }

    
    override func topMenuDidSelectIndex(_ index: Int) {
        
        self.collectionView.alpha = 0
        
        if index == 0 {
            showConnectButton()
            self.data = self.aboutData
            self.collectionView.reloadData()
        }
        else if index == 1 {
            hideConnectButton()
            self.data = self.projectsData
            self.collectionView.reloadData()
        }
        else if index == 2 {
            hideConnectButton()
            self.data = self.membersData
            self.collectionView.reloadData()
        }

        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            let cell = self.collectionView.cellForItem(at: IndexPath(row: 1, section: 0))
            self.collectionView.setContentOffset(CGPoint.init(x: 0, y: (cell?.frame.origin.y ?? self.collectionView.frame.height) - 90), animated: false)
            UIView.animate(withDuration: 0.3, delay: 0.1, options: .curveEaseInOut, animations: {
                self.collectionView.alpha = 1
            }, completion: { (_) in
                
            })
        }
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        super.scrollViewDidScroll(scrollView)
        if let topCell = collectionView.cellForItem(at: IndexPath(item: 0, section: 0)) as? CompanyDetailTopCell {
            topCell.didScrollWith(offsetY: scrollView.contentOffset.y)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if let vm = data[indexPath.item] as? CompanyAboutViewModel {
            let cellWidth: CGFloat = self.collectionView.frame.width - 40
            var height:CGFloat = 100
            if let about = vm.company.about {
                height = about.height(withConstrainedWidth: cellWidth, font:UIFont(name: "GTWalsheim-Light", size: 12.5)!)
                height += 50 // add extra height for the standard elements, titles, lines, sapcing etc.
            }
            return CGSize(width: view.frame.width, height: height)
        }

        if let vm = data[indexPath.item] as? CompanyServiceItemViewModel {
            let cellWidth: CGFloat = self.collectionView.frame.width - 40
            // TODO: Get the height here form the rpoper service item text, that is not yet added in the model...
            let height = vm.service.description.height(withConstrainedWidth: cellWidth, font:UIFont(name: "GTWalsheim-Light", size: 12.5)!) + 50 // add extra height for the standard elements, titles, lines, sapcing etc.
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
            cellSize = CGSize(width: view.frame.width, height: collectionView.frame.height)
        }
        return cellSize
        
    }
    
    var selectMember: Member?
    var selectProject: Project?
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let vm = data[indexPath.item] as? MemberViewModel {
            self.selectMember = vm.member
            self.performSegue(withIdentifier: "ShowMember", sender: self)
        }
        else if let vm = data[indexPath.item] as? ProjectViewModel {
            self.selectProject = vm.project
            self.performSegue(withIdentifier: "ShowProject", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if segue.identifier == "ShowMember" {
            if let vc = segue.destination as? MemberViewController, let selectMember = selectMember {
                vc.member = selectMember
            }
        }
        else if segue.identifier == "ShowProject" {
            if let vc = segue.destination as? ProjectViewController, let selectProject = selectProject {
                vc.project = selectProject
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
            if let vc = segue.destination as? MessagesThreadViewController, let member = self.memberToSendMessage {
                vc.member = member
            }
        }
    }
    
    @IBAction func connectTap(_ sender: Any) {
        guard let website = company?.website else { return }
        
        if let url = URL(string: website) {
            let svc = SFSafariViewController(url: url)
            self.present(svc, animated: true, completion: nil)
        }
    }
    
    override func didCreatePost(post: Post) {
        
    }
    
    override func didCreateComment(comment: Comment) {
        
    }
    
    override func didSendContactRequest() {
        self.cellWantsToSendContactRequest?.connectRequestStatus = .outstanding
        
        // Now refresh the status, so that when we push into the member, it can update the button correctly.
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        firstly {
            ContactRequestManager.shared.refresh()
            }.then { contactRequests -> Void in
                for data in self.data {
                    if let data2 = data as? MemberViewModel {
                        data2.member.contactRequest = ContactRequestManager.shared.getRelevantContactRequestFor(member: data2.member)
                    }
                }
            }.always {
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            }.catch { error in
                debugPrint(error.localizedDescription)
        }
    }
    
}

extension CompanyViewController {
    
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

extension CompanyViewController: CellBackDelegate {
    func goBack() {
        self.navigationController?.popViewController(animated: true)
    }
}



