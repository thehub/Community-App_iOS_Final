//
//  CompaniesViewController.swift
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

        if(traitCollection.forceTouchCapability == .available){
            registerForPreviewing(with: self, sourceView: self.collectionView)
        }
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib.init(nibName: "MemberCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "MemberCell")
        
        let item1 = Member(name: "Niklas", job: "Developer", photo: "photo", blurb: "Lorem ipsum dolor sit amet, habitasse a suspendisse et, nec suscipit imperdiet sed, libero mollis felis egestas vivamus velit, felis velit interdum phasellus luctus, nulla molestie felis ligula diam.", aboutMe: "Lorem ipsum dolor sit amet, habitasse a suspendisse et, nec suscipit imperdiet sed, libero mollis felis egestas vivamus velit, felis velit interdum phasellus luctus, nulla molestie felis ligula diam. Lorem ipsum dolor sit amet, habitasse a suspendisse et, nec suscipit imperdiet sed, libero mollis felis egestas vivamus velit, felis velit interdum phasellus luctus, nulla molestie felis ligula diam. Lorem ipsum dolor sit amet, habitasse a suspendisse et, nec suscipit imperdiet sed, libero mollis felis egestas vivamus velit, felis velit interdum phasellus luctus, nulla molestie felis ligula diam.", locationName: "London")
        let item2 = Member(name: "Neela", job: "Salesforce", photo: "photo", blurb: "Lorem ipsum dolor sit amet, habitasse a suspendisse et, nec suscipit imperdiet sed, libero mollis felis egestas vivamus velit, felis velit interdum phasellus luctus, nulla molestie felis ligula diam.", aboutMe: "Lorem ipsum dolor sit amet, habitasse a suspendisse et, nec suscipit imperdiet sed, libero mollis felis egestas vivamus velit, felis velit interdum phasellus luctus, nulla molestie felis ligula diam.", locationName: "London")
        let item3 = Member(name: "Russel", job: "Salesforce", photo: "photo", blurb: "Lorem ipsum dolor sit amet, habitasse a suspendisse et, nec suscipit imperdiet sed, libero mollis felis egestas vivamus velit, felis velit interdum phasellus luctus, nulla molestie felis ligula diam.", aboutMe: "Lorem ipsum dolor sit amet, habitasse a suspendisse et, nec suscipit imperdiet sed, libero mollis felis egestas vivamus velit, felis velit interdum phasellus luctus, nulla molestie felis ligula diam.", locationName: "London")
        let item4 = Member(name: "Rob", job: "UX", photo: "photo", blurb: "Lorem ipsum dolor sit amet, habitasse a suspendisse et, nec suscipit imperdiet sed, libero mollis felis egestas vivamus velit, felis velit interdum phasellus luctus, nulla molestie felis ligula diam.", aboutMe: "Lorem ipsum dolor sit amet, habitasse a suspendisse et, nec suscipit imperdiet sed, libero mollis felis egestas vivamus velit, felis velit interdum phasellus luctus, nulla molestie felis ligula diam.", locationName: "London")

        let cellWidth: CGFloat = self.view.frame.width - 30
        let viewModel1 = MemberViewModel(member: item1, cellSize: CGSize(width: cellWidth, height: 200))
        let viewModel2 = MemberViewModel(member: item2, cellSize: CGSize(width: cellWidth, height: 200))
        let viewModel3 = MemberViewModel(member: item3, cellSize: CGSize(width: cellWidth, height: 200))
        let viewModel4 = MemberViewModel(member: item4, cellSize: CGSize(width: cellWidth, height: 200))
        
        self.data.append(viewModel1)
        self.data.append(viewModel2)
        self.data.append(viewModel3)
        self.data.append(viewModel4)
        
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    var selectedVM: MemberViewModel?
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowMember" {
            if let vc = segue.destination as? MemberViewController, let selectedItem = selectedVM {
                vc.member = selectedItem.member
            }
        }
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
        if let vm = data[indexPath.item] as? MemberViewModel {
            selectedVM = vm
            performSegue(withIdentifier: "ShowMember", sender: self)
        }
    }
}

extension MembersViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return data[indexPath.item].cellSize
        
    }
}

extension MembersViewController: UIViewControllerPreviewingDelegate {
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        
        guard let indexPath = collectionView.indexPathForItem(at: location) else { return nil }
        guard let cell = collectionView.cellForItem(at: indexPath) else { return nil }

        var detailVC: UIViewController!

        if let vm = data[indexPath.item] as? MemberViewModel {
            selectedVM = vm
            detailVC = storyboard?.instantiateViewController(withIdentifier: "MemberViewController")
            (detailVC as! MemberViewController).member = selectedVM?.member

            //        detailVC.preferredContentSize = CGSize(width: 0.0, height: 300)
            previewingContext.sourceRect = cell.frame
            
            return detailVC
        }
        
        return nil
        
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        show(viewControllerToCommit, sender: self)
    }
    
}
