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
    

    @IBOutlet weak var connectButton: UIButton!
    @IBOutlet weak var titleLabelTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var topMenu: TopMenu!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var data = [CellRepresentable]()
    var memberFeedData = [CellRepresentable]()
    var memberAboutData = [CellRepresentable]()

    var titleLabelTopConstraintDefult: CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true

        connectButton.setTitle("Connect with \(member.name)", for: .normal)

        titleLabel.text = member.name
        
        collectionView.register(UINib.init(nibName: MemberDetailTopViewModel.cellIdentifier, bundle: nil), forCellWithReuseIdentifier: MemberDetailTopViewModel.cellIdentifier)
        collectionView.register(UINib.init(nibName: MemberFeedItemViewModel.cellIdentifier, bundle: nil), forCellWithReuseIdentifier: MemberFeedItemViewModel.cellIdentifier)
        collectionView.register(UINib.init(nibName: MemberAboutItemViewModel.cellIdentifier, bundle: nil), forCellWithReuseIdentifier: MemberAboutItemViewModel.cellIdentifier)

        topMenu.delegate = self
        
        topMenu.setupWithItems(["Feed", "About", "Projects", "Groups"])

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
        memberFeedData = data
        self.data = memberFeedData

        var data2 = [CellRepresentable]()
        data2.append(MemberDetailTopViewModel(member: member, cellSize: .zero)) // this will pick the full height instead
        data2.append(MemberAboutItemViewModel(member: member, cellSize: CGSize(width: view.frame.width, height: 80)))
        data2.append(MemberAboutItemViewModel(member: member, cellSize: CGSize(width: view.frame.width, height: 80)))
        data2.append(MemberAboutItemViewModel(member: member, cellSize: CGSize(width: view.frame.width, height: 80)))
        data2.append(MemberAboutItemViewModel(member: member, cellSize: CGSize(width: view.frame.width, height: 80)))
        self.memberAboutData = data2

        
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    var didLayout = false
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if !didLayout {
            didLayout = true
            titleLabelTopConstraintDefult = titleLabelTopConstraint.constant
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.navigationController?.navigationBar.shadowImage = nil

    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var cellSize = data[indexPath.item].cellSize
        if cellSize == .zero {
            let cellHeight = self.view.frame.height - self.connectButton.frame.height - ((self.navigationController?.navigationBar.frame.height) ?? 0)
            cellSize = CGSize(width: view.frame.width, height: cellHeight)
        }
        return cellSize
        
    }
    
    func topMenuDidSelectIndex(_ index: Int) {
        
        self.collectionView.alpha = 0

        if index == 0 {
            self.data = self.memberFeedData
            self.collectionView.reloadData()
        }
        else if index == 1 {
            self.data = self.memberAboutData
            self.collectionView.reloadData()
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.collectionView.setContentOffset(CGPoint.init(x: 0, y: self.collectionView.frame.height - 80), animated: false)
            UIView.animate(withDuration: 0.3, delay: 0.1, options: .curveEaseInOut, animations: {
                self.collectionView.alpha = 1
            }, completion: { (_) in
                
            })
        }
        
        
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y > 200 && !topMenu.isShow {
            topMenu.show()
        }
        else if scrollView.contentOffset.y < 200 && topMenu.isShow {
            topMenu.hide()
        }
        
        let newTitleYPos = titleLabelTopConstraintDefult - scrollView.contentOffset.y
        if newTitleYPos > -195 {
            titleLabelTopConstraint.constant = newTitleYPos
        }
        else {
            titleLabelTopConstraint.constant = -195
        }
        
        
        
        
    }
    
    @IBAction func connectTap(_ sender: Any) {
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
        
        let cell = data[indexPath.item].cellInstance(collectionView, indexPath: indexPath)
//        if let topCell = cell as? MemberDetailTopCell {
//            debugPrint("container \(topCell.contentView.frame.size.height)")
//            debugPrint("nameLabel \(topCell.nameLabel.frame.origin.y)")
//            let newPoint = topCell.nameLabel.convert(topCell.nameLabel.frame.origin, to: self.view)
//            debugPrint(newPoint.y)
//            debugPrint(self.view.frame.height)
//            titleLabelTopConstraintDefult = newPoint.y + 50 + ((self.view.frame.height - 568)/2)
//            titleLabelTopConstraint.constant = titleLabelTopConstraintDefult

//            "container 300.0"
//            "nameLabel 102.0"
//            215.5
//            736.0
            
//            "container 300.0"
//            "nameLabel 102.0"
//            215.5
//            568.0
            
            // 736 = 433

//        }
        
        return cell
    }
}

