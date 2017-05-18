//
//  MemberViewController.swift
//  ImpactHub
//
//  Created by Niklas on 18/05/2017.
//  Copyright © 2017 Lightful Ltd. All rights reserved.
//

import UIKit

class MemberViewController: UIViewController, UICollectionViewDelegate, TopMenuDelegate, UICollectionViewDelegateFlowLayout {

    var member: Member!
    

    @IBOutlet weak var topMenu: TopMenu!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var memberFeedDataSource: MemberDataSource?
    var memberAboutDataSource: MemberDataSource?
    var data = [CellRepresentable]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // TODO: Pull this dynamically form the view models
        collectionView.register(UINib.init(nibName: "MemberDetailTopCell", bundle: nil), forCellWithReuseIdentifier: "MemberDetailTopCell")
        collectionView.register(UINib.init(nibName: "MemberFeedItemCell", bundle: nil), forCellWithReuseIdentifier: "MemberFeedItemCell")
        collectionView.register(UINib.init(nibName: "MemberAboutItemCell", bundle: nil), forCellWithReuseIdentifier: "MemberAboutItemCell")

        topMenu.delegate = self

        var data = [CellRepresentable]()
        data.append(MemberDetailTopViewModel(member: member, cellSize: .zero)) // this will pick the full height instead
        data.append(MemberFeedItemViewModel(member: member, cellSize: CGSize(width: view.frame.width, height: 115)))
        data.append(MemberFeedItemViewModel(member: member, cellSize: CGSize(width: view.frame.width, height: 115)))
        data.append(MemberFeedItemViewModel(member: member, cellSize: CGSize(width: view.frame.width, height: 115)))
        data.append(MemberFeedItemViewModel(member: member, cellSize: CGSize(width: view.frame.width, height: 115)))
        data.append(MemberFeedItemViewModel(member: member, cellSize: CGSize(width: view.frame.width, height: 115)))
        data.append(MemberFeedItemViewModel(member: member, cellSize: CGSize(width: view.frame.width, height: 115)))
        data.append(MemberFeedItemViewModel(member: member, cellSize: CGSize(width: view.frame.width, height: 115)))
        data.append(MemberFeedItemViewModel(member: member, cellSize: CGSize(width: view.frame.width, height: 115)))
        self.memberFeedDataSource = MemberDataSource(data: data)
        self.data = memberFeedDataSource!.data

        var data2 = [CellRepresentable]()
        data2.append(MemberDetailTopViewModel(member: member, cellSize: .zero)) // this will pick the full height instead
        data2.append(MemberAboutItemViewModel(member: member, cellSize: CGSize(width: view.frame.width, height: 80)))
        data2.append(MemberAboutItemViewModel(member: member, cellSize: CGSize(width: view.frame.width, height: 80)))
        data2.append(MemberAboutItemViewModel(member: member, cellSize: CGSize(width: view.frame.width, height: 80)))
        data2.append(MemberAboutItemViewModel(member: member, cellSize: CGSize(width: view.frame.width, height: 80)))
        self.memberAboutDataSource = MemberDataSource(data: data2)

        
        collectionView.delegate = self
        collectionView.dataSource = memberFeedDataSource
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var cellSize = data[indexPath.item].cellSize
        if cellSize == .zero {
            cellSize = CGSize(width: view.frame.width, height: collectionView.frame.height)
        }
        return cellSize
        
    }
    
    func topMenuDidSelectIndex(_ index: Int) {
        if index == 0 {
            collectionView.dataSource = memberFeedDataSource
            data = memberFeedDataSource!.data
            collectionView.reloadData()
        }
        else if index == 1 {
            collectionView.dataSource = memberAboutDataSource
            data = memberAboutDataSource!.data
            collectionView.reloadData()
        }
        
        collectionView.setContentOffset(CGPoint.init(x: 0, y: self.collectionView.frame.height - 80), animated: true)
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y > 200 && !topMenu.isShow {
            topMenu.show()
        }
        else if scrollView.contentOffset.y < 200 && topMenu.isShow {
            topMenu.hide()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

