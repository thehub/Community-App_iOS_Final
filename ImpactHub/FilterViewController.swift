//
//  FilterViewController.swift
//  ImpactHub
//
//  Created by Niklas Alvaeus on 27/06/2017.
//  Copyright © 2017 Lightful Ltd. All rights reserved.
//

import UIKit
import PromiseKit

class FilterViewController: UIViewController {

    var data = [CellRepresentable]()

    @IBOutlet weak var collectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.register(UINib.init(nibName: FilterGroupingViewModel.cellIdentifier, bundle: nil), forCellWithReuseIdentifier: FilterGroupingViewModel.cellIdentifier)

        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)

        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        let cellWidth: CGFloat = self.view.frame.width
        firstly {
            APIClient.shared.getFilters(grouping: .city)
            }.then { items -> Void in
                if let first = items.first {
                    let viewModel = FilterGroupingViewModel(grouping: first.grouping, cellSize: CGSize(width: cellWidth, height: 37))
                    self.data.append(viewModel)
                }
            }.then {
                APIClient.shared.getFilters(grouping: .sector)
            }.then { items -> Void in
                if let first = items.first {
                    let viewModel = FilterGroupingViewModel(grouping: first.grouping, cellSize: CGSize(width: cellWidth, height: 37))
                    self.data.append(viewModel)
                }
            }.always {
                self.collectionView.alpha = 0
                self.collectionView.reloadData()
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
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

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
    }

    var selectedFilters: [Filter]?


}

extension FilterViewController {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let vm = data[indexPath.item] as? FilterGroupingViewModel {
//            selectedFilters = vm
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
