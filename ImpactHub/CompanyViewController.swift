//
//  MemberViewController.swift
//  ImpactHub
//
//  Created by Niklas on 18/05/2017.
//  Copyright © 2017 Lightful Ltd. All rights reserved.
//

import UIKit
import PromiseKit

class CompanyViewController: UIViewController, UICollectionViewDelegate, TopMenuDelegate, UICollectionViewDelegateFlowLayout {

    var company: Company?
    var compnayId: String?
    
    

    @IBOutlet weak var connectButton: UIButton!
    @IBOutlet weak var topMenu: TopMenu!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var data = [CellRepresentable]()
    var aboutData = [CellRepresentable]()
    var projectsData = [CellRepresentable]()

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
        connectButton.setTitle("Connect with \(company.name)", for: .normal)
        
        collectionView.register(UINib.init(nibName: CompanyDetailTopViewModel.cellIdentifier, bundle: nil), forCellWithReuseIdentifier: CompanyDetailTopViewModel.cellIdentifier)
        collectionView.register(UINib.init(nibName: CompanyAboutViewModel.cellIdentifier, bundle: nil), forCellWithReuseIdentifier: CompanyAboutViewModel.cellIdentifier)
        
        topMenu.delegate = self
        
        topMenu.setupWithItems(["About", "Projects", "Members"])
        
        var data = [CellRepresentable]()
        data.append(CompanyDetailTopViewModel(company: company, cellSize: .zero)) // this will pick the full height instead
        data.append(CompanyAboutViewModel(company: company, cellSize: CGSize(width: view.frame.width, height: 450)))
        aboutData = data
        self.data = aboutData
        //
        //        var data2 = [CellRepresentable]()
        //        data2.append(MemberDetailTopViewModel(member: member, cellSize: .zero)) // this will pick the full height instead
        //        data2.append(MemberAboutItemViewModel(member: member, cellSize: CGSize(width: view.frame.width, height: 80)))
        //        data2.append(MemberAboutItemViewModel(member: member, cellSize: CGSize(width: view.frame.width, height: 80)))
        //        data2.append(MemberAboutItemViewModel(member: member, cellSize: CGSize(width: view.frame.width, height: 80)))
        //        data2.append(MemberAboutItemViewModel(member: member, cellSize: CGSize(width: view.frame.width, height: 80)))
        //        self.memberAboutData = data2
        
        
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var cellSize = data[indexPath.item].cellSize
        if cellSize == .zero {
            cellSize = CGSize(width: view.frame.width, height: collectionView.frame.height)
        }
        return cellSize
        
    }
    
    func topMenuDidSelectIndex(_ index: Int) {
        
        self.collectionView.alpha = 0

        if index == 0 {
            self.data = self.aboutData
            self.collectionView.reloadData()
        }
//        else if index == 1 {
//            self.data = self.projectsData
//            self.collectionView.reloadData()
//        }

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
    }
    
    @IBAction func connectTap(_ sender: Any) {
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension CompanyViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return data[indexPath.item].cellInstance(collectionView, indexPath: indexPath)
    }
}

