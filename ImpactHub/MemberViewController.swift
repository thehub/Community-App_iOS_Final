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
    @IBOutlet weak var titleLabelContainerView: UIView!
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
        
        connectButton.setTitle("Connect with \(member.name)", for: .normal)

        titleLabel.text = member.name
        
        collectionView.register(UINib.init(nibName: MemberDetailTopViewModel.cellIdentifier, bundle: nil), forCellWithReuseIdentifier: MemberDetailTopViewModel.cellIdentifier)
        collectionView.register(UINib.init(nibName: MemberFeedItemViewModel.cellIdentifier, bundle: nil), forCellWithReuseIdentifier: MemberFeedItemViewModel.cellIdentifier)
        collectionView.register(UINib.init(nibName: MemberAboutItemViewModel.cellIdentifier, bundle: nil), forCellWithReuseIdentifier: MemberAboutItemViewModel.cellIdentifier)
        collectionView.register(UINib.init(nibName: MemberSkillItemViewModel.cellIdentifier, bundle: nil), forCellWithReuseIdentifier: MemberSkillItemViewModel.cellIdentifier)

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
        data2.append(MemberSkillItemViewModel(member: member, cellSize: CGSize(width: view.frame.width, height: 40)))
        data2.append(MemberSkillItemViewModel(member: member, cellSize: CGSize(width: view.frame.width, height: 40)))
        data2.append(MemberSkillItemViewModel(member: member, cellSize: CGSize(width: view.frame.width, height: 40)))
        self.memberAboutData = data2

        
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseInOut, animations: {
            self.setNeedsStatusBarAppearanceUpdate()
        }) { (_) in
            
        }

        
//        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
//        self.navigationController?.navigationBar.shadowImage = UIImage()
//        self.navigationController?.navigationBar.isTranslucent = true
//        self.navigationController?.view.backgroundColor = UIColor.clear
//        self.navigationController?.navigationBar.backgroundColor = UIColor.clear
//        
//        
//        
//        self.navigationController?.navigationBar.layer.borderColor = UIColor.clear.cgColor
//        self.navigationController?.navigationBar.layer.borderWidth = 0
//        self.navigationController?.navigationBar.layer.shadowColor = UIColor.clear.cgColor
//        self.navigationController?.navigationBar.layer.shadowOffset = CGSize.zero
//        self.navigationController?.navigationBar.layer.shadowRadius = 0
//        self.navigationController?.navigationBar.layer.shadowOpacity = 0
//        self.navigationController?.navigationBar.layer.masksToBounds = true

        
        
    }
    

    var shouldHideStatusBar = true
    
    override var prefersStatusBarHidden: Bool {
        return shouldHideStatusBar
    }
    
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return .slide
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
        
//        self.navigationController?.navigationBar.shadowImage = nil

    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        
        if let vm = data[indexPath.item] as? MemberAboutItemViewModel {
            let cellWidth: CGFloat = self.collectionView.frame.width
            let height = vm.member.aboutMe.height(withConstrainedWidth: cellWidth, font: UIFont.systemFont(ofSize: 17)) + 50
            return CGSize(width: view.frame.width, height: height)
        }
        
        var cellSize = data[indexPath.item].cellSize
        if cellSize == .zero {
            let cellHeight = self.view.frame.height
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
            UIApplication.shared.setStatusBarHidden(false, with: UIStatusBarAnimation.slide)
            self.shouldHideStatusBar = false
            self.navigationController?.setNavigationBarHidden(false, animated: true)
            
            UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseInOut, animations: {
                self.setNeedsStatusBarAppearanceUpdate()
            }) { (_) in
                
            }
            
        }
        else if scrollView.contentOffset.y < 200 && topMenu.isShow {
            topMenu.hide()
            self.navigationController?.setNavigationBarHidden(true, animated: true)
            self.shouldHideStatusBar = true
            self.navigationController?.setNavigationBarHidden(true, animated: true)
            UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseInOut, animations: {
                self.setNeedsStatusBarAppearanceUpdate()
            }) { (_) in
                
            }
        }

        
        // Sync titleLabel
        let newTitleYPos = titleLabelTopConstraintDefult - scrollView.contentOffset.y
        let newTitleYPosConverted = titleLabelContainerView.convert(CGPoint(x: 0, y: newTitleYPos), to: self.view)
        
        if newTitleYPosConverted.y > 30 {
            titleLabelTopConstraint.constant = newTitleYPos
        }
        else {
            let fixPoint = self.view.convert(CGPoint(x: 0, y: 30), to: titleLabelContainerView)
            titleLabelTopConstraint.constant = fixPoint.y
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

