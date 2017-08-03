//
//  FilterViewController.swift
//  ImpactHub
//
//  Created by Niklas Alvaeus on 27/06/2017.
//  Copyright © 2017 Lightful Ltd. All rights reserved.
//

import UIKit
import PromiseKit
import DeckTransition

class FilterViewController: UIViewController {

    var dataAll = [CellRepresentable]()
    var data = [CellRepresentable]()
    var filterData = [[CellRepresentable]]()

    weak var delegate: FilterableDelegate?

    
    @IBOutlet weak var collectionView: UICollectionView!

    @available(iOS 10.0, *)
    var generatorImpact: UIImpactFeedbackGenerator {
        return UIImpactFeedbackGenerator(style: .medium)
    }

    @available(iOS 10.0, *)
    var generatorNotification: UINotificationFeedbackGenerator {
        return UINotificationFeedbackGenerator()
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.register(UINib.init(nibName: FilterGroupingViewModel.cellIdentifier, bundle: nil), forCellWithReuseIdentifier: FilterGroupingViewModel.cellIdentifier)

        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)

        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        self.filterData = FilterManager.shared.filterData
        self.dataAll = FilterManager.shared.dataViewModel
        self.update()

        if #available(iOS 10.0, *) {
            generatorImpact.prepare()
            generatorNotification.prepare()
            self.generatorImpact.impactOccurred()
        }

    }

    override func viewWillDisappear(_ animated: Bool) {
        self.delegate?.updateFilters(filters: FilterManager.shared.getCurrentFilters())
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        update()
    }
    
    func update() {
        let filters = FilterManager.shared.getCurrentFilters()
        
        self.data = self.dataAll
        // Set all to false first
        data.forEach { (cellData) in
            (cellData as! FilterGroupingViewModel).hasSome = false
        }
        
        // Compare each data against fitler items, to see if it matches the grouping
        data.forEach { (cellData) in
            if cellData is FilterGroupingViewModel {
                if filters.filter({$0.grouping == (cellData as! FilterGroupingViewModel).grouping}).count > 0 {
                    (cellData as! FilterGroupingViewModel).hasSome = true
                }
            }
        }
        
        collectionView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func onDoneTap(_ sender: Any) {
        if #available(iOS 10.0, *) {
            self.generatorNotification.notificationOccurred(.success)
        }
        self.presentingViewController?.dismiss(animated: true, completion: {
        })
    }
    
    @IBAction func onClearAll(_ sender: Any) {
        if #available(iOS 10.0, *) {
            self.generatorNotification.notificationOccurred(.success)
        }
        FilterManager.shared.clearAll()
        update()
    }

    var selectedFilterData: [CellRepresentable]?

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowFilterDetail" {
            if let vc = segue.destination as? FilterDetailViewController, let selectedFilterData = selectedFilterData {
                vc.data = selectedFilterData
                vc.delegate = self.delegate
            }
        }
    }

}

extension FilterViewController {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let vm = data[indexPath.item] as? FilterGroupingViewModel {
            var indexFound = 0
            for (index, tmp) in filterData.enumerated() {
                if (tmp.first as? FilterViewModel)?.filter.grouping == vm.grouping {
                    indexFound = index
                    break
                }
            }
            selectedFilterData = filterData[indexFound]
            performSegue(withIdentifier: "ShowFilterDetail", sender: self)
        }
    }
}

extension FilterViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return data[indexPath.item].cellInstance(collectionView, indexPath: indexPath)
    }
}

extension FilterViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: collectionView.frame.size.width, height: data[indexPath.item].cellSize.height)
        
    }
}
