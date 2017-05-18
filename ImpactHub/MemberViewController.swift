//
//  MemberViewController.swift
//  ImpactHub
//
//  Created by Niklas on 18/05/2017.
//  Copyright © 2017 Lightful Ltd. All rights reserved.
//

import UIKit

class MemberViewController: UIViewController, UIScrollViewDelegate {

    var member: Member!
    
    var data = [CellRepresentable]()

    @IBOutlet weak var topMenu: TopMenu!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib.init(nibName: "MemberDetailTopCell", bundle: nil), forCellWithReuseIdentifier: "MemberDetailTopCell")
        collectionView.register(UINib.init(nibName: "MemberFeedItemCell", bundle: nil), forCellWithReuseIdentifier: "MemberFeedItemCell")

        
        // Add things to be displayed in the collectionview
        data.append(MemberDetailTopViewModel(member: member))

        data.append(MemberFeedItemViewModel(member: member))
        data.append(MemberFeedItemViewModel(member: member))
        data.append(MemberFeedItemViewModel(member: member))
        data.append(MemberFeedItemViewModel(member: member))
        data.append(MemberFeedItemViewModel(member: member))
        data.append(MemberFeedItemViewModel(member: member))
        data.append(MemberFeedItemViewModel(member: member))
        data.append(MemberFeedItemViewModel(member: member))

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


extension MemberViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return data[indexPath.item].cellInstance(collectionView, indexPath: indexPath)
    }
}


extension MemberViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let cellWidth: CGFloat = self.view.frame.width
        return CGSize(width: cellWidth, height: data[indexPath.item].rowHeight)
        
    }
}
