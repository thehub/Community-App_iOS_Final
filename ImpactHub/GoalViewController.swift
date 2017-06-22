//
//  MemberViewController.swift
//  ImpactHub
//
//  Created by Niklas on 18/05/2017.
//  Copyright © 2017 Lightful Ltd. All rights reserved.
//

import UIKit

class GoalViewController: ListFullBleedViewController {

    var goal: Goal!
    
    var member = Member.init(name: "Test", job: "Test", photo: "photo", blurb: "test", aboutMe: "test", locationName: "London")

    var aboutData = [CellRepresentable]()
    var groupsData = [CellRepresentable]()
    var membersData = [CellRepresentable]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = goal.name
        
        collectionView.register(UINib.init(nibName: GoalDetailTopViewModel.cellIdentifier, bundle: nil), forCellWithReuseIdentifier: GoalDetailTopViewModel.cellIdentifier)
        collectionView.register(UINib.init(nibName: GoalAboutItemViewModel.cellIdentifier, bundle: nil), forCellWithReuseIdentifier: GoalAboutItemViewModel.cellIdentifier)
        collectionView.register(UINib.init(nibName: GoalViewModel.cellIdentifier, bundle: nil), forCellWithReuseIdentifier: GoalViewModel.cellIdentifier)
        collectionView.register(UINib.init(nibName: MemberViewModel.cellIdentifier, bundle: nil), forCellWithReuseIdentifier: MemberViewModel.cellIdentifier)
        collectionView.register(UINib.init(nibName: TitleViewModel.cellIdentifier, bundle: nil), forCellWithReuseIdentifier: TitleViewModel.cellIdentifier)
        collectionView.register(UINib.init(nibName: GroupViewModel.cellIdentifier, bundle: nil), forCellWithReuseIdentifier: GroupViewModel.cellIdentifier)

        
        topMenu.setupWithItems(["ABOUT", "GROUPS", "MEMBERS"])

        // Feed
        aboutData.append(GoalDetailTopViewModel(goal: goal, cellSize: .zero)) // this will pick the full height instead
        aboutData.append(GoalAboutItemViewModel(goal: goal, cellSize: CGSize(width: view.frame.width, height: 0)))
        self.data = aboutData


        // Groups
        groupsData.append(GoalDetailTopViewModel(goal: goal, cellSize: .zero)) // this will pick the full height instead
        
        let group1 = Group(id: "aasdsa", title: "A guide to reaching your sustainable development goals", photo: "groupPhoto", body: "A guide to reaching your sustainable development goals", memberCount: 400, locationName: "London, UK")
        let group2 = Group(id: "aasdsa", title: "Zero to one: new startups and Innovative Ideas", photo: "groupPhoto", body: "Zero to one: new startups and Innovative Ideas", memberCount: 160, locationName: "Amsterdam, NL")
        groupsData.append(TitleViewModel(title: "", cellSize: CGSize(width: view.frame.width, height: 40)))
        groupsData.append(GroupViewModel(group: group1, cellSize: CGSize(width: view.frame.width, height: 165)))
        groupsData.append(GroupViewModel(group: group2, cellSize: CGSize(width: view.frame.width, height: 165)))
        groupsData.append(GroupViewModel(group: group1, cellSize: CGSize(width: view.frame.width, height: 165)))
        groupsData.append(GroupViewModel(group: group2, cellSize: CGSize(width: view.frame.width, height: 165)))
        groupsData.append(GroupViewModel(group: group1, cellSize: CGSize(width: view.frame.width, height: 165)))


        
        // Members
        membersData.append(GoalDetailTopViewModel(goal: goal, cellSize: .zero)) // this will pick the full height instead
        membersData.append(TitleViewModel(title: "", cellSize: CGSize(width: view.frame.width, height: 40)))

        
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
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        
        if let vm = data[indexPath.item] as? GoalAboutItemViewModel {
            let cellWidth: CGFloat = self.collectionView.frame.width
            let height = vm.goal.blurb.height(withConstrainedWidth: cellWidth, font:UIFont(name: "GTWalsheim-Light", size: 12.5)!) + 145 // add extra height for the standard elements, titles, lines, sapcing etc.
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
        if segue.identifier == "ShowGroup" {
            if let vc = segue.destination as? GroupViewController, let selectGroup = selectGroup {
                vc.group = selectGroup
            }
        }
        if segue.identifier == "ShowMember" {
            if let vc = segue.destination as? MemberViewController, let selectMember = selectMember {
                vc.member = selectMember
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


    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}


