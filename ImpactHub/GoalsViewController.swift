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

    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.register(UINib.init(nibName: GoalViewModel.cellIdentifier, bundle: nil), forCellWithReuseIdentifier: GoalViewModel.cellIdentifier)
        
        let item1 = Goal(name: "What Important issues is the community working", blurb: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.", photo: "goalPhoto")
        let item2 = Goal(name: "A guide to reaching your sustainable development goals", blurb: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua", photo: "goalPhoto")
        let item3 = Goal(name: "What Important issues is the community working", blurb: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.", photo: "goalPhoto")
        let item4 = Goal(name: "A guide to reaching your sustainable development goals", blurb: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua", photo: "goalPhoto")
        
        
        let cellWidth: CGFloat = self.view.frame.width
        let viewModel1 = GoalViewModel(goal: item1, cellSize: CGSize(width: cellWidth, height: 370))
        let viewModel2 = GoalViewModel(goal: item2, cellSize: CGSize(width: cellWidth, height: 370))
        let viewModel3 = GoalViewModel(goal: item3, cellSize: CGSize(width: cellWidth, height: 370))
        let viewModel4 = GoalViewModel(goal: item4, cellSize: CGSize(width: cellWidth, height: 370))
        
        self.allData.append(viewModel1)
        self.allData.append(viewModel2)
        self.allData.append(viewModel3)
        self.allData.append(viewModel4)

        self.allData.append(viewModel1)
        self.allData.append(viewModel2)
        self.allData.append(viewModel3)
        self.allData.append(viewModel4)

        self.allData.append(viewModel1)
        self.allData.append(viewModel2)
        self.allData.append(viewModel3)
        self.allData.append(viewModel4)
        
        self.data = allData
        
        self.sustainableData.append(viewModel1)
        self.sustainableData.append(viewModel2)

        self.humanData.append(viewModel2)
        self.humanData.append(viewModel1)

        
        topMenu.setupWithItems(["ALL", "SUSTAINABLE DEVELOPMENT", "HUMAN RIGHTS"])

        // Do any additional setup after loading the view.
        
        
//        UIApplication.shared.isNetworkActivityIndicatorVisible = true
//        firstly {
//            APIClient.shared.getJobs(skip: 0, top: 100)
//            }.then { items -> Void in
//                print(items)
////                self.dataSource = items
////                self.collectionView?.reloadData()
//            }.always {
//                UIApplication.shared.isNetworkActivityIndicatorVisible = false
//            }.catch { error in
//                debugPrint(error.localizedDescription)
//        }
    
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
            self.collectionView.setContentOffset(CGPoint.init(x: 0, y: -20), animated: false)
            UIView.animate(withDuration: 0.3, delay: 0.1, options: .curveEaseInOut, animations: {
                self.collectionView.setContentOffset(CGPoint.init(x: 0, y: 0), animated: false)
                self.collectionView.alpha = 1
            }, completion: { (_) in
                
            })
        }
        
        
    }

    
    var selectedVM: GoalViewModel?
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
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
