//
//  MembersViewController.swift
//  ImpactHub
//
//  Created by Niklas on 17/05/2017.
//  Copyright © 2017 Lightful Ltd. All rights reserved.
//

import UIKit

class MembersViewController: UIViewController {

    var data = [CellRepresentable]()

    
    @IBOutlet weak var collectionView: UICollectionView!


    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib.init(nibName: "MemberCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "MemberCell")
        
        let member1 = Member(name: "Niklas", job: "Developer")
        let member2 = Member(name: "Neela", job: "Salesforce")
        let member3 = Member(name: "Russel", job: "Salesforce")
        
        let viewModel1 = MemberViewModel(member: member1)
        let viewModel2 = MemberViewModel(member: member2)
        let viewModel3 = MemberViewModel(member: member3)
        
        self.data.append(viewModel1)
        self.data.append(viewModel2)
        self.data.append(viewModel3)
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension MembersViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return data[indexPath.item].cellInstance(collectionView, indexPath: indexPath)
    }
}

extension MembersViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}

extension MembersViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let cellWidth: CGFloat = self.view.frame.width - 30
        return CGSize(width: cellWidth, height: 250)
        
    }
}
