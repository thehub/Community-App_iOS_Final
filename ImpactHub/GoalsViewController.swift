//
//  CompaniesViewController.swift
//  ImpactHub
//
//  Created by Niklas on 17/05/2017.
//  Copyright © 2017 Lightful Ltd. All rights reserved.
//

import UIKit
import PromiseKit

class GoalsViewController: ListWithTopMenuViewController {

    var allData = [CellRepresentable]()
    var sustainableData = [CellRepresentable]()
    var humanData = [CellRepresentable]()

    var offset: Int?
    var firstLoad = true
    var isLoading = false

    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.register(UINib.init(nibName: GoalViewModel.cellIdentifier, bundle: nil), forCellWithReuseIdentifier: GoalViewModel.cellIdentifier)
        
        loadData()
        
//        topMenu.setupWithItems(["ALL", "SUSTAINABLE DEVELOPMENT", "HUMAN RIGHTS"])
        topMenu?.hide()
    
    }
    
    fileprivate func loadData() {
        self.isLoading = true
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        self.collectionView?.alpha = 0
        firstly {
            APIClient.shared.getGoals(offset: self.offset ?? 0)
            }.then { result -> Void in
                let items = result.goals
                self.offset = result.offset
                let cellWidth: CGFloat = self.view.frame.width - 30
                items.forEach({ (goal) in
                    self.allData.append(GoalViewModel(goal: goal, cellSize: CGSize(width: cellWidth, height: 370)))
                })
                let previousCount = self.data.count
                self.data = self.allData
                
                // TODO: Once in Salesforce
                //        self.sustainableData.append(viewModel1)
                //        self.sustainableData.append(viewModel2)
                //
                //        self.humanData.append(viewModel2)
                //        self.humanData.append(viewModel1)
                if self.firstLoad {
                    self.collectionView?.reloadData()
                }
                else {
                    let indexPaths = (previousCount..<self.data.count).map { IndexPath(row: $0, section: 0) }
                    self.collectionView.insertItems(at: indexPaths)
                }
            }.always {
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                if self.firstLoad {
                    self.collectionView?.alpha = 0
                    self.collectionView?.reloadData()
                    self.collectionView?.setContentOffset(CGPoint.init(x: 0, y: -80), animated: false)
                    UIView.animate(withDuration: 0.3, delay: 0.1, options: .curveEaseInOut, animations: {
                        self.collectionView?.setContentOffset(CGPoint.init(x: 0, y: -60), animated: false)
                        self.collectionView?.alpha = 1
                    }, completion: { (_) in
                        
                    })
                    self.firstLoad = false
                }
            }.catch { error in
                debugPrint(error.localizedDescription)
                self.isLoading = false
        }
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        super.scrollViewDidScroll(scrollView)
        if !isLoading && self.offset != nil && scrollView.contentOffset.y > scrollView.contentSize.height * 0.70 {
            loadData()
        }
    }
    
    deinit {
        print("\(#file, #function)")
    }
    
    override func topMenuDidSelectIndex(_ index: Int) {
        
        self.collectionView.alpha = 0
        
        if index == 0 {
            self.data = self.allData
            self.collectionView.reloadData()
        }
        else if index == 1 {
            self.data = self.sustainableData
            self.collectionView.reloadData()
        }
        else if index == 2 {
            self.data = self.humanData
            self.collectionView.reloadData()
        }
//        self.collectionView.scrollRectToVisible(CGRect.zero, animated: false)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.collectionView.setContentOffset(CGPoint.init(x: 0, y: -80), animated: false)
            UIView.animate(withDuration: 0.3, delay: 0.1, options: .curveEaseInOut, animations: {
                self.collectionView.setContentOffset(CGPoint.init(x: 0, y: -60), animated: false)
                self.collectionView.alpha = 1
            }, completion: { (_) in
                
            })
        }
        
        
    }

    
    var selectedVM: GoalViewModel?
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if segue.identifier == "ShowGoal" {
            if let vc = segue.destination as? GoalViewController, let selectedItem = selectedVM {
                vc.goal = selectedItem.goal
            }
        }
    }
    
    
}

extension GoalsViewController {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let vm = data[indexPath.item] as? GoalViewModel {
            selectedVM = vm
            performSegue(withIdentifier: "ShowGoal", sender: self)
        }
    }
}

extension GoalsViewController {
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let cellWidth: CGFloat = self.collectionView.frame.width
        let width = ((cellWidth - 40) / 2.2)
        let heightToUse = width + 165
        return CGSize(width: view.frame.width, height: heightToUse)
        
    }
}

extension GoalsViewController {
    
    override func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        
        guard let indexPath = collectionView.indexPathForItem(at: location) else { return nil }
        guard let cell = collectionView.cellForItem(at: indexPath) else { return nil }

        var detailVC: UIViewController!

        if let vm = data[indexPath.item] as? GoalViewModel {
            selectedVM = vm
            detailVC = storyboard?.instantiateViewController(withIdentifier: "GoalViewController")
            (detailVC as! GoalViewController).goal = selectedVM?.goal

            //        detailVC.preferredContentSize = CGSize(width: 0.0, height: 300)
            previewingContext.sourceRect = cell.frame
            
            return detailVC
        }
        
        return nil
        
    }
    
    override func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        show(viewControllerToCommit, sender: self)
    }
    
}
