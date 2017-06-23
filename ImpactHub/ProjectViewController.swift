//
//  MemberViewController.swift
//  ImpactHub
//
//  Created by Niklas on 18/05/2017.
//  Copyright © 2017 Lightful Ltd. All rights reserved.
//

import UIKit

class ProjectViewController: ListFullBleedViewController {

    var project: Project!
    
    var member = Member.init(name: "Test", job: "Test", photo: "photo", blurb: "test", aboutMe: "test", locationName: "London")

    var projectFeedData = [CellRepresentable]()
    var projectsObjectivesData = [CellRepresentable]()
    var projectsMembersData = [CellRepresentable]()
    var projectsJobsData = [CellRepresentable]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = project.name
        
        collectionView.register(UINib.init(nibName: ProjectDetailTopViewModel.cellIdentifier, bundle: nil), forCellWithReuseIdentifier: ProjectDetailTopViewModel.cellIdentifier)
        collectionView.register(UINib.init(nibName: MemberFeedItemViewModel.cellIdentifier, bundle: nil), forCellWithReuseIdentifier: MemberFeedItemViewModel.cellIdentifier)
        collectionView.register(UINib.init(nibName: ProjectViewModel.cellIdentifier, bundle: nil), forCellWithReuseIdentifier: ProjectViewModel.cellIdentifier)
        collectionView.register(UINib.init(nibName: MemberViewModel.cellIdentifier, bundle: nil), forCellWithReuseIdentifier: MemberViewModel.cellIdentifier)
        collectionView.register(UINib.init(nibName: TitleViewModel.cellIdentifier, bundle: nil), forCellWithReuseIdentifier: TitleViewModel.cellIdentifier)
        collectionView.register(UINib.init(nibName: ProjectObjectiveViewModel.cellIdentifier, bundle: nil), forCellWithReuseIdentifier: ProjectObjectiveViewModel.cellIdentifier)
        collectionView.register(UINib.init(nibName: JobViewModel.cellIdentifier, bundle: nil), forCellWithReuseIdentifier: JobViewModel.cellIdentifier)

        
        topMenu.setupWithItems(["FEED", "OBJECTIVES", "MEMBERS", "JOBS"])

        // Feed
        projectFeedData.append(ProjectDetailTopViewModel(project: project, cellSize: .zero)) // this will pick the full height instead
        projectFeedData.append(TitleViewModel(title: "DISCUSSIONS", cellSize: CGSize(width: view.frame.width, height: 70)))
        projectFeedData.append(MemberFeedItemViewModel(member: member, cellSize: CGSize(width: view.frame.width, height: 150)))
        projectFeedData.append(MemberFeedItemViewModel(member: member, cellSize: CGSize(width: view.frame.width, height: 150)))
        projectFeedData.append(MemberFeedItemViewModel(member: member, cellSize: CGSize(width: view.frame.width, height: 150)))
        projectFeedData.append(MemberFeedItemViewModel(member: member, cellSize: CGSize(width: view.frame.width, height: 150)))
        self.data = projectFeedData


        // Objectives
        projectsObjectivesData.append(ProjectDetailTopViewModel(project: project, cellSize: .zero)) // this will pick the full height instead
        projectsObjectivesData.append(TitleViewModel(title: "GOALS", cellSize: CGSize(width: view.frame.width, height: 70)))
        projectsObjectivesData.append(ProjectObjectiveViewModel(objective: Project(name: "Zero to one: new startups and Innovative Ideas").objectives[0], cellSize: CGSize(width: view.frame.width, height: 0)))
        projectsObjectivesData.append(ProjectObjectiveViewModel(objective: Project(name: "Zero to one: new startups and Innovative Ideas").objectives[1], cellSize: CGSize(width: view.frame.width, height: 0)))
        projectsObjectivesData.append(ProjectObjectiveViewModel(objective: Project(name: "Zero to one: new startups and Innovative Ideas").objectives[2], cellSize: CGSize(width: view.frame.width, height: 0)))
        projectsObjectivesData.append(ProjectObjectiveViewModel(objective: Project(name: "Zero to one: new startups and Innovative Ideas").objectives[3], cellSize: CGSize(width: view.frame.width, height: 0)))

        
        // Members
        projectsMembersData.append(ProjectDetailTopViewModel(project: project, cellSize: .zero)) // this will pick the full height instead
        projectsMembersData.append(TitleViewModel(title: "", cellSize: CGSize(width: view.frame.width, height: 70)))

        
        let item1 = Member(name: "Niklas", job: "Developer", photo: "photo", blurb: "Lorem ipsum dolor sit amet, habitasse a suspendisse et, nec suscipit imperdiet sed, libero mollis felis egestas vivamus velit, felis velit interdum phasellus luctus, nulla molestie felis ligula diam.", aboutMe: "Lorem ipsum dolor sit amet, habitasse a suspendisse et, nec suscipit imperdiet sed, libero mollis felis egestas vivamus velit, felis velit interdum phasellus luctus, nulla molestie felis ligula diam. Lorem ipsum dolor sit amet, habitasse a suspendisse et, nec suscipit imperdiet sed, libero mollis felis egestas vivamus velit, felis velit interdum phasellus luctus, nulla molestie felis ligula diam. Lorem ipsum dolor sit amet, habitasse a suspendisse et, nec suscipit imperdiet sed, libero mollis felis egestas vivamus velit, felis velit interdum phasellus luctus, nulla molestie felis ligula diam.", locationName: "London")
        let item2 = Member(name: "Neela", job: "Salesforce", photo: "photo", blurb: "Lorem ipsum dolor sit amet, habitasse a suspendisse et, nec suscipit imperdiet sed, libero mollis felis egestas vivamus velit, felis velit interdum phasellus luctus, nulla molestie felis ligula diam.", aboutMe: "Lorem ipsum dolor sit amet, habitasse a suspendisse et, nec suscipit imperdiet sed, libero mollis felis egestas vivamus velit, felis velit interdum phasellus luctus, nulla molestie felis ligula diam.", locationName: "London")
        let item3 = Member(name: "Russel", job: "Salesforce", photo: "photo", blurb: "Lorem ipsum dolor sit amet, habitasse a suspendisse et, nec suscipit imperdiet sed, libero mollis felis egestas vivamus velit, felis velit interdum phasellus luctus, nulla molestie felis ligula diam.", aboutMe: "Lorem ipsum dolor sit amet, habitasse a suspendisse et, nec suscipit imperdiet sed, libero mollis felis egestas vivamus velit, felis velit interdum phasellus luctus, nulla molestie felis ligula diam.", locationName: "London")
        let item4 = Member(name: "Rob", job: "UX", photo: "photo", blurb: "Lorem ipsum dolor sit amet, habitasse a suspendisse et, nec suscipit imperdiet sed, libero mollis felis egestas vivamus velit, felis velit interdum phasellus luctus, nulla molestie felis ligula diam.", aboutMe: "Lorem ipsum dolor sit amet, habitasse a suspendisse et, nec suscipit imperdiet sed, libero mollis felis egestas vivamus velit, felis velit interdum phasellus luctus, nulla molestie felis ligula diam.", locationName: "London")
        
        let cellWidth: CGFloat = self.view.frame.width
        let viewModel1 = MemberViewModel(member: item1, cellSize: CGSize(width: cellWidth, height: 105))
        let viewModel2 = MemberViewModel(member: item2, cellSize: CGSize(width: cellWidth, height: 105))
        let viewModel3 = MemberViewModel(member: item3, cellSize: CGSize(width: cellWidth, height: 105))
        let viewModel4 = MemberViewModel(member: item4, cellSize: CGSize(width: cellWidth, height: 105))
        
        projectsMembersData.append(viewModel1)
        projectsMembersData.append(viewModel2)
        projectsMembersData.append(viewModel3)
        projectsMembersData.append(viewModel4)

        projectsMembersData.append(viewModel1)
        projectsMembersData.append(viewModel2)
        projectsMembersData.append(viewModel3)
        projectsMembersData.append(viewModel4)
        
        // Jobs
        projectsJobsData.append(ProjectDetailTopViewModel(project: project, cellSize: .zero)) // this will pick the full height instead
        let company = Company(id: "dsfsd", name: "Swift", type: "dsfsdfs", photo: "companyImage", logo:"companyLogo", blurb: "Lorem ipsum", locationName: "Amsterdam, UK", website: "www.bbc.co.uk", size: "10 - 20")
        
        projectsJobsData.append(TitleViewModel(title: "JOBS FOR THIS PROJECT", cellSize: CGSize(width: view.frame.width, height: 70)))
        
        let job1 = Job(id: "zxddz", name: "UI Designer", company: company, description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.", locationName: "London, UK", type: "Fulltime", salary: "€ 10.000 / 20.000 p/a", companyName: "Swift", companyId: "dsfsdfsdfs")
        
        
        let viewModelJob1 = JobViewModel(job: job1, cellSize: CGSize(width: cellWidth, height: 145))
        let viewModelJob2 = JobViewModel(job: job1, cellSize: CGSize(width: cellWidth, height: 145))
        let viewModelJob3 = JobViewModel(job: job1, cellSize: CGSize(width: cellWidth, height: 145))
        let viewModelJob4 = JobViewModel(job: job1, cellSize: CGSize(width: cellWidth, height: 145))
        
        projectsJobsData.append(viewModelJob1)
        projectsJobsData.append(viewModelJob2)
        projectsJobsData.append(viewModelJob3)
        projectsJobsData.append(viewModelJob4)

        
        
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


    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}


