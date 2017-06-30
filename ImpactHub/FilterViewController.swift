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

    var data = [CellRepresentable]()
    var filterData = [[CellRepresentable]]()

    weak var delegate: FilterableDelegate?

    
    @IBOutlet weak var collectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()

//        
//        if let transitioningDelegate = transitioningDelegate as? DeckTransitioningDelegate {
//            
//            transitioningDelegate.
//        }
        
        collectionView.register(UINib.init(nibName: FilterGroupingViewModel.cellIdentifier, bundle: nil), forCellWithReuseIdentifier: FilterGroupingViewModel.cellIdentifier)

        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)

        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        let cellWidth: CGFloat = self.view.frame.width
        
        switch FilterManager.shared.currenttlySelectingFor {
        case .members, .companies, .events, .jobs, .projects:
            firstly {
                APIClient.shared.getFilters(grouping: .city)
                }.then { items -> Void in
                    let sortedItems = items.sorted(by: {$0.name < $1.name})
                    if let first = sortedItems.first {
                        let viewModel = FilterGroupingViewModel(grouping: first.grouping, cellSize: CGSize(width: cellWidth, height: 37))
                        self.data.append(viewModel)
                    }
                    let filters = sortedItems.map({FilterViewModel(filter: $0, cellSize: CGSize(width: cellWidth, height: 37))})
                    self.filterData.append(filters)
                }.then {
                    APIClient.shared.getFilters(grouping: .sector)
                }.then { items -> Void in
                    let sortedItems = items.sorted(by: {$0.name < $1.name})
                    if let first = sortedItems.first {
                        let viewModel = FilterGroupingViewModel(grouping: first.grouping, cellSize: CGSize(width: cellWidth, height: 37))
                        self.data.append(viewModel)
                    }
                    let filters = items.map({FilterViewModel(filter: $0, cellSize: CGSize(width: cellWidth, height: 37))})
                    self.filterData.append(filters)
                }.always {
                    self.collectionView.alpha = 0
                    self.update()
                    self.collectionView.setContentOffset(CGPoint.init(x: 0, y: -20), animated: false)
                    UIView.animate(withDuration: 0.3, delay: 0.1, options: .curveEaseInOut, animations: {
                        self.collectionView.setContentOffset(CGPoint.init(x: 0, y: 0), animated: false)
                        self.collectionView.alpha = 1
                    }, completion: { (_) in
                        
                    })
                    
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                }.catch { error in
                    debugPrint(error.localizedDescription)
            }
            break
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
        print(filters)
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
        self.presentingViewController?.dismiss(animated: true, completion: {
        })
    }
    
    @IBAction func onClearAll(_ sender: Any) {
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
            selectedFilterData = filterData[indexPath.item]
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
        
        return data[indexPath.item].cellSize
        
    }
}
