//
//  CompaniesViewController.swift
//  ImpactHub
//
//  Created by Niklas on 17/05/2017.
//  Copyright © 2017 Lightful Ltd. All rights reserved.
//

import UIKit
import PromiseKit

class ProjectsViewController: ListWithSearchViewController {

    var allData = [CellRepresentable]()
    var projectsYouManageData = [CellRepresentable]()
    var yourProjectsData = [CellRepresentable]()

    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.register(UINib.init(nibName: ProjectViewModel.cellIdentifier, bundle: nil), forCellWithReuseIdentifier: ProjectViewModel.cellIdentifier)
        
        let item1 = Project(name: "Zero to one: new startups and Innovative Ideas", image: "projectImage")
        let item2 = Project(name: "Zero to one: new startups and Innovative Ideas", image: "projectImage")
        let item3 = Project(name: "Zero to one: new startups and Innovative Ideas", image: "projectImage")
        let item4 = Project(name: "Zero to one: new startups and Innovative Ideas", image: "projectImage")
        
        
        let cellWidth: CGFloat = self.view.frame.width
        let viewModel1 = ProjectViewModel(project: item1, cellSize: CGSize(width: cellWidth, height: 370))
        let viewModel2 = ProjectViewModel(project: item2, cellSize: CGSize(width: cellWidth, height: 370))
        let viewModel3 = ProjectViewModel(project: item3, cellSize: CGSize(width: cellWidth, height: 370))
        let viewModel4 = ProjectViewModel(project: item4, cellSize: CGSize(width: cellWidth, height: 370))
        
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
        
        // todo:
        self.projectsYouManageData = Array(allData[0...4])
        self.yourProjectsData = Array(allData[4...7])

        
        topMenu?.setupWithItems(["ALL", "PROJECTS YOU MANAGE", "YOUR PROJECTS"])

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
    

    
    var selectedVM: ProjectViewModel?
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowProject" {
            if let vc = segue.destination as? ProjectViewController, let selectedItem = selectedVM {
                vc.project = selectedItem.project
            }
        }
    }
    
    override func topMenuDidSelectIndex(_ index: Int) {
        
        self.collectionView.alpha = 0
        
        if index == 0 {
            self.data = self.allData
            self.collectionView.reloadData()
        }
        else if index == 1 {
            self.data = self.projectsYouManageData
            self.collectionView.reloadData()
        }
        else if index == 2 {
            self.data = self.yourProjectsData
            self.collectionView.reloadData()
        }
        self.collectionView.scrollRectToVisible(CGRect.zero, animated: false)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.collectionView.setContentOffset(CGPoint.init(x: 0, y: -20), animated: false)
            UIView.animate(withDuration: 0.3, delay: 0.1, options: .curveEaseInOut, animations: {
                self.collectionView.setContentOffset(CGPoint.init(x: 0, y: 0), animated: false)
                self.collectionView.alpha = 1
            }, completion: { (_) in
                
            })
        }
    }
    
}

extension ProjectsViewController {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let vm = data[indexPath.item] as? ProjectViewModel {
            selectedVM = vm
            performSegue(withIdentifier: "ShowProject", sender: self)
        }
    }
}

extension ProjectsViewController {
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let cellWidth: CGFloat = self.collectionView.frame.width
        let width = ((cellWidth - 40) / 1.6)
        let heightToUse = width + 155
        return CGSize(width: view.frame.width, height: heightToUse)
        
    }
}

extension ProjectsViewController {
    
    override func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        
        guard let indexPath = collectionView.indexPathForItem(at: location) else { return nil }
        guard let cell = collectionView.cellForItem(at: indexPath) else { return nil }

        var detailVC: UIViewController!

        if let vm = data[indexPath.item] as? ProjectViewModel {
            selectedVM = vm
            detailVC = storyboard?.instantiateViewController(withIdentifier: "ProjectViewController")
            (detailVC as! ProjectViewController).project = selectedVM?.project

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
