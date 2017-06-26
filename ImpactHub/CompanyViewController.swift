//
//  MemberViewController.swift
//  ImpactHub
//
//  Created by Niklas on 18/05/2017.
//  Copyright © 2017 Lightful Ltd. All rights reserved.
//

import UIKit
import PromiseKit

class CompanyViewController: ListFullBleedViewController {

    var company: Company?
    var compnayId: String?
    

    var aboutData = [CellRepresentable]()
    var projectsData = [CellRepresentable]()
    var membersData = [CellRepresentable]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.company != nil {
            build()
        }
        else if let companyId = self.compnayId {
            // Load in compnay
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
            firstly {
                APIClient.shared.getCompany(companyId: companyId)
                }.then { item -> Void in
                    self.company = item
                    self.build()
                }.always {
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                }.catch { error in
                    debugPrint(error.localizedDescription)
            }
            
        }
        else {
            debugPrint("No Company or companyId")
        }
        
    }
    
    func build() {
        guard let company = self.company else {
            return
        }
        
        if let website = company.website {
            connectButton?.setTitle("\(website)", for: .normal)
        }
        else {
            connectButton?.isHidden = true
        }
        
        self.title = company.name
        
        collectionView.register(UINib.init(nibName: CompanyDetailTopViewModel.cellIdentifier, bundle: nil), forCellWithReuseIdentifier: CompanyDetailTopViewModel.cellIdentifier)
        collectionView.register(UINib.init(nibName: CompanyAboutViewModel.cellIdentifier, bundle: nil), forCellWithReuseIdentifier: CompanyAboutViewModel.cellIdentifier)
        collectionView.register(UINib.init(nibName: TitleViewModel.cellIdentifier, bundle: nil), forCellWithReuseIdentifier: TitleViewModel.cellIdentifier)
        collectionView.register(UINib.init(nibName: ProjectViewModel.cellIdentifier, bundle: nil), forCellWithReuseIdentifier: ProjectViewModel.cellIdentifier)
        collectionView.register(UINib.init(nibName: MemberViewModel.cellIdentifier, bundle: nil), forCellWithReuseIdentifier: MemberViewModel.cellIdentifier)
        collectionView.register(UINib.init(nibName: CompanyServiceItemViewModel.cellIdentifier, bundle: nil), forCellWithReuseIdentifier: CompanyServiceItemViewModel.cellIdentifier)


        topMenu?.setupWithItems(["About", "Projects", "Members"])
        
        // About
        aboutData.append(CompanyDetailTopViewModel(company: company, cellSize: .zero)) // this will pick the full height instead
        aboutData.append(TitleViewModel(title: "ABOUT", cellSize: CGSize(width: view.frame.width, height: 60)))
        aboutData.append(CompanyAboutViewModel(company: company, cellSize: CGSize(width: view.frame.width, height: 0)))
        aboutData.append(CompanyServiceItemViewModel(company: company, cellSize: CGSize(width: view.frame.width, height: 0)))
        aboutData.append(CompanyServiceItemViewModel(company: company, cellSize: CGSize(width: view.frame.width, height: 0)))
        aboutData.append(CompanyServiceItemViewModel(company: company, cellSize: CGSize(width: view.frame.width, height: 0)))
        aboutData.append(CompanyServiceItemViewModel(company: company, cellSize: CGSize(width: view.frame.width, height: 0)))
        aboutData.append(CompanyServiceItemViewModel(company: company, cellSize: CGSize(width: view.frame.width, height: 0)))
        aboutData.append(CompanyServiceItemViewModel(company: company, cellSize: CGSize(width: view.frame.width, height: 0)))
        aboutData.append(CompanyServiceItemViewModel(company: company, cellSize: CGSize(width: view.frame.width, height: 0)))
        
        
        self.data = aboutData
        
        // Projects
        projectsData.append(CompanyDetailTopViewModel(company: company, cellSize: .zero)) // this will pick the full height instead
        
        projectsData.append(ProjectViewModel(project: Project(name: "Zero to one: new startups and Innovative Ideas", image: "projectImage"), cellSize: CGSize(width: view.frame.width, height: 370)))
        
        projectsData.append(ProjectViewModel(project: Project(name: "Zero to one: new startups and Innovative Ideas", image: "projectImage"), cellSize: CGSize(width: view.frame.width, height: 370)))
        
        projectsData.append(ProjectViewModel(project: Project(name: "Zero to one: new startups and Innovative Ideas", image: "projectImage"), cellSize: CGSize(width: view.frame.width, height: 370)))
        
        projectsData.append(ProjectViewModel(project: Project(name: "Zero to one: new startups and Innovative Ideas", image: "projectImage"), cellSize: CGSize(width: view.frame.width, height: 370)))
        
        projectsData.append(ProjectViewModel(project: Project(name: "Zero to one: new startups and Innovative Ideas", image: "projectImage"), cellSize: CGSize(width: view.frame.width, height: 370)))
        
        projectsData.append(ProjectViewModel(project: Project(name: "Zero to one: new startups and Innovative Ideas", image: "projectImage"), cellSize: CGSize(width: view.frame.width, height: 370)))
        
        projectsData.append(ProjectViewModel(project: Project(name: "Zero to one: new startups and Innovative Ideas", image: "projectImage"), cellSize: CGSize(width: view.frame.width, height: 370)))
        
        projectsData.append(ProjectViewModel(project: Project(name: "Zero to one: new startups and Innovative Ideas", image: "projectImage"), cellSize: CGSize(width: view.frame.width, height: 370)))
        
        projectsData.append(ProjectViewModel(project: Project(name: "Zero to one: new startups and Innovative Ideas", image: "projectImage"), cellSize: CGSize(width: view.frame.width, height: 370)))
        
        projectsData.append(ProjectViewModel(project: Project(name: "Zero to one: new startups and Innovative Ideas", image: "projectImage"), cellSize: CGSize(width: view.frame.width, height: 370)))
        
        projectsData.append(ProjectViewModel(project: Project(name: "Zero to one: new startups and Innovative Ideas", image: "projectImage"), cellSize: CGSize(width: view.frame.width, height: 370)))
        
        
        
        // Members
        
        membersData.append(CompanyDetailTopViewModel(company: company, cellSize: .zero)) // this will pick the full height instead
        membersData.append(TitleViewModel(title: "", cellSize: CGSize(width: view.frame.width, height: 70)))
        
        let item1 = Member(name: "Niklas", job: "Developer", photo: "photo", blurb: "Lorem ipsum dolor sit amet, habitasse a suspendisse et, nec suscipit imperdiet sed, libero mollis felis egestas vivamus velit, felis velit interdum phasellus luctus, nulla molestie felis ligula diam.", aboutMe: "Lorem ipsum dolor sit amet, habitasse a suspendisse et, nec suscipit imperdiet sed, libero mollis felis egestas vivamus velit, felis velit interdum phasellus luctus, nulla molestie felis ligula diam. Lorem ipsum dolor sit amet, habitasse a suspendisse et, nec suscipit imperdiet sed, libero mollis felis egestas vivamus velit, felis velit interdum phasellus luctus, nulla molestie felis ligula diam. Lorem ipsum dolor sit amet, habitasse a suspendisse et, nec suscipit imperdiet sed, libero mollis felis egestas vivamus velit, felis velit interdum phasellus luctus, nulla molestie felis ligula diam.", locationName: "London")
        let item2 = Member(name: "Neela", job: "Salesforce", photo: "photo", blurb: "Lorem ipsum dolor sit amet, habitasse a suspendisse et, nec suscipit imperdiet sed, libero mollis felis egestas vivamus velit, felis velit interdum phasellus luctus, nulla molestie felis ligula diam.", aboutMe: "Lorem ipsum dolor sit amet, habitasse a suspendisse et, nec suscipit imperdiet sed, libero mollis felis egestas vivamus velit, felis velit interdum phasellus luctus, nulla molestie felis ligula diam.", locationName: "London")
        let item3 = Member(name: "Russel", job: "Salesforce", photo: "photo", blurb: "Lorem ipsum dolor sit amet, habitasse a suspendisse et, nec suscipit imperdiet sed, libero mollis felis egestas vivamus velit, felis velit interdum phasellus luctus, nulla molestie felis ligula diam.", aboutMe: "Lorem ipsum dolor sit amet, habitasse a suspendisse et, nec suscipit imperdiet sed, libero mollis felis egestas vivamus velit, felis velit interdum phasellus luctus, nulla molestie felis ligula diam.", locationName: "London")
        let item4 = Member(name: "Rob", job: "UX", photo: "photo", blurb: "Lorem ipsum dolor sit amet, habitasse a suspendisse et, nec suscipit imperdiet sed, libero mollis felis egestas vivamus velit, felis velit interdum phasellus luctus, nulla molestie felis ligula diam.", aboutMe: "Lorem ipsum dolor sit amet, habitasse a suspendisse et, nec suscipit imperdiet sed, libero mollis felis egestas vivamus velit, felis velit interdum phasellus luctus, nulla molestie felis ligula diam.", locationName: "London")
        
        let cellWidth: CGFloat = self.view.frame.width
        let viewModel1 = MemberViewModel(member: item1, cellSize: CGSize(width: cellWidth, height: 105))
        let viewModel2 = MemberViewModel(member: item2, cellSize: CGSize(width: cellWidth, height: 105))
        let viewModel3 = MemberViewModel(member: item3, cellSize: CGSize(width: cellWidth, height: 105))
        let viewModel4 = MemberViewModel(member: item4, cellSize: CGSize(width: cellWidth, height: 105))
        
        membersData.append(viewModel1)
        membersData.append(viewModel2)
        membersData.append(viewModel3)
        membersData.append(viewModel4)
        
        membersData.append(viewModel1)
        membersData.append(viewModel2)
        membersData.append(viewModel3)
        membersData.append(viewModel4)

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
            self.collectionView.setContentOffset(CGPoint.init(x: 0, y: self.collectionView.frame.height - 0), animated: false)
            UIView.animate(withDuration: 0.3, delay: 0.1, options: .curveEaseInOut, animations: {
                self.collectionView.alpha = 1
            }, completion: { (_) in
                
            })
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if let vm = data[indexPath.item] as? CompanyAboutViewModel {
            let cellWidth: CGFloat = self.collectionView.frame.width
            let height = vm.company.blurb.height(withConstrainedWidth: cellWidth, font:UIFont(name: "GTWalsheim-Light", size: 12.5)!) + 50 // add extra height for the standard elements, titles, lines, sapcing etc.
            return CGSize(width: view.frame.width, height: height)
        }

        if let vm = data[indexPath.item] as? CompanyServiceItemViewModel {
            let cellWidth: CGFloat = self.collectionView.frame.width
            // TODO: Get the height here form the rpoper service item text, that is not yet added in the model...
            let height = vm.company.blurb.height(withConstrainedWidth: cellWidth, font:UIFont(name: "GTWalsheim-Light", size: 12.5)!) + 50 // add extra height for the standard elements, titles, lines, sapcing etc.
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
        if segue.identifier == "ShowMember" {
            if let vc = segue.destination as? MemberViewController, let selectMember = selectMember {
                vc.member = selectMember
            }
        }
        if segue.identifier == "ShowProject" {
            if let vc = segue.destination as? ProjectViewController, let selectProject = selectProject {
                vc.project = selectProject
            }
        }
    }
    
    @IBAction func connectTap(_ sender: Any) {
        guard let website = company?.website else { return }
        
        let url = URL(string: website)!
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
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


