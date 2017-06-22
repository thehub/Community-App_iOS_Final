//
//  MemberViewController.swift
//  ImpactHub
//
//  Created by Niklas on 18/05/2017.
//  Copyright © 2017 Lightful Ltd. All rights reserved.
//

import UIKit

class GroupViewController: ListFullBleedViewController {

    var group: Group!
    
    var feedData = [CellRepresentable]()

    var member = Member.init(name: "Niklas", job: "Developer", photo: "photo", blurb: "test", aboutMe: "test", locationName: "London")

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = group.title
        
        collectionView.register(UINib.init(nibName: GroupDetailTopViewModel.cellIdentifier, bundle: nil), forCellWithReuseIdentifier: GroupDetailTopViewModel.cellIdentifier)
        collectionView.register(UINib.init(nibName: MemberFeedItemViewModel.cellIdentifier, bundle: nil), forCellWithReuseIdentifier: MemberFeedItemViewModel.cellIdentifier)
        collectionView.register(UINib.init(nibName: TitleViewModel.cellIdentifier, bundle: nil), forCellWithReuseIdentifier: TitleViewModel.cellIdentifier)

        collectionView.register(UINib.init(nibName: GroupViewModel.cellIdentifier, bundle: nil), forCellWithReuseIdentifier: GroupViewModel.cellIdentifier)

        
//        topMenu.setupWithItems(["ABOUT", "GROUPS", "MEMBERS"])
        topMenu.hide()
        
        // Feed
        // Feed
        feedData.append(GroupDetailTopViewModel(group: group, cellSize: .zero)) // this will pick the full height instead
        feedData.append(TitleViewModel(title: "DISCUSSION", cellSize: CGSize(width: view.frame.width, height: 70)))
        feedData.append(MemberFeedItemViewModel(member: member, cellSize: CGSize(width: view.frame.width, height: 150)))
        feedData.append(MemberFeedItemViewModel(member: member, cellSize: CGSize(width: view.frame.width, height: 150)))
        feedData.append(MemberFeedItemViewModel(member: member, cellSize: CGSize(width: view.frame.width, height: 150)))
        feedData.append(MemberFeedItemViewModel(member: member, cellSize: CGSize(width: view.frame.width, height: 150)))
        self.data = feedData
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        
        if let vm = data[indexPath.item] as? MemberFeedItemViewModel {
            let cellWidth: CGFloat = self.collectionView.frame.width
            let height = vm.feedText.height(withConstrainedWidth: cellWidth, font:UIFont(name: "GTWalsheim-Light", size: 12.5)!) + 145 // add extra height for the standard elements, titles, lines, sapcing etc.
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "ShowMember" {
//            if let vc = segue.destination as? MemberViewController, let selectMember = selectMember {
//                vc.member = selectMember
//            }
//        }
    }
    
    override func topMenuDidSelectIndex(_ index: Int) {

    }


    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}


