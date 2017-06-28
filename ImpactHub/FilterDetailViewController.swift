//
//  FilterDetailViewController.swift
//  ImpactHub
//
//  Created by Niklas Alvaeus on 27/06/2017.
//  Copyright © 2017 Lightful Ltd. All rights reserved.
//

import UIKit
import PromiseKit

class FilterDetailViewController: UIViewController {
    
    var data = [CellRepresentable]()
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.register(UINib.init(nibName: FilterViewModel.cellIdentifier, bundle: nil), forCellWithReuseIdentifier: FilterViewModel.cellIdentifier)
        
        collectionView.allowsMultipleSelection = true
        // Do any additional setup after loading the view.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let first = data.first as? FilterViewModel {
            title = first.filter.grouping.displayName
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func onDoneTap(_ sender: Any) {
        self.presentingViewController?.dismiss(animated: true, completion: {
            
        })
    }
    
    @IBAction func onClearAll(_ sender: Any) {
        let selectedItems = collectionView.indexPathsForSelectedItems
        
        selectedItems?.forEach({ (indexPath) in
            collectionView.deselectItem(at: indexPath, animated:true)
            //            if let cell = followCollectionView.cellForItemAtIndexPath(indexPath) as? FollowCell {
            //                cell.checkImg.hidden = true
            //            }
        })
        
        
    }
    
    var selectedFilters: [Filter]?
    
    
}

extension FilterDetailViewController {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

    }
}

extension FilterDetailViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return data[indexPath.item].cellInstance(collectionView, indexPath: indexPath)
    }
}

extension FilterDetailViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return data[indexPath.item].cellSize
        
    }
}
