//
//  CompaniesViewController.swift
//  ImpactHub
//
//  Created by Niklas on 17/05/2017.
//  Copyright © 2017 Lightful Ltd. All rights reserved.
//

import UIKit
import PromiseKit
import SalesforceSDKCore

class ProjectsViewController: ListWithSearchViewController {

    var projectsYouManageData = [CellRepresentable]()
    var yourProjectsData = [CellRepresentable]()

    override var filterSource: FilterManager.Source {
        get {
            return FilterManager.Source.projects
        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.register(UINib.init(nibName: ProjectViewModel.cellIdentifier, bundle: nil), forCellWithReuseIdentifier: ProjectViewModel.cellIdentifier)
        
        topMenu?.setupWithItems(["ALL", "PROJECTS YOU MANAGE", "YOUR PROJECTS"])

        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        self.collectionView?.alpha = 0
        firstly {
            APIClient.shared.getProjects()
            }.then { items -> Void in
                let cellWidth: CGFloat = self.view.frame.width
                items.forEach({ (project) in
                    let viewModel = ProjectViewModel(project: project, cellSize: CGSize(width: cellWidth, height: 370))
                    self.dataAll.append(viewModel)
                    if viewModel.project.createdById == SessionManager.shared.me?.member.id {
                        self.projectsYouManageData.append(viewModel)
                    }
                })
                self.data = self.dataAll
            }.then {_ in 
                APIClient.shared.getProjects(contactId: SessionManager.shared.me?.member.id ?? "")
            }.then { yourProjects -> Void in
                let cellWidth: CGFloat = self.view.frame.width
                yourProjects.forEach({ (project) in
                    let viewModel = ProjectViewModel(project: project, cellSize: CGSize(width: cellWidth, height: 370))
                    self.yourProjectsData.append(viewModel)
                })
            }.always {
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                self.collectionView?.alpha = 0
                self.collectionView?.reloadData()
                self.collectionView?.setContentOffset(CGPoint.init(x: 0, y: -20), animated: false)
                UIView.animate(withDuration: 0.3, delay: 0.1, options: .curveEaseInOut, animations: {
                    self.collectionView?.setContentOffset(CGPoint.init(x: 0, y: 0), animated: false)
                    self.collectionView?.alpha = 1
                }, completion: { (_) in
                    
                })
                
            }.catch { error in
                debugPrint(error.localizedDescription)
        }
        
    }
    

    
    var selectedVM: ProjectViewModel?
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: self)
        if segue.identifier == "ShowProject" {
            if let vc = segue.destination as? ProjectViewController, let selectedItem = selectedVM {
                vc.project = selectedItem.project
            }
        }
    }
    
    override func topMenuDidSelectIndex(_ index: Int) {
        
        self.collectionView.alpha = 0
        
        if index == 0 {
            self.cancelSearching()
            self.data = self.dataAll
            self.collectionView.reloadData()
        }
        else if index == 1 {
            self.cancelSearching()
            self.data = self.projectsYouManageData
            self.collectionView.reloadData()
        }
        else if index == 2 {
            self.cancelSearching()
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
    
    // MARK: Search
    override func filterContentForSearchText(searchText:String) -> [CellRepresentable] {
        return self.dataAll.filter({ (item) -> Bool in
            if let vm = item as? ProjectViewModel {
                let companyName = vm.project.companyName ?? ""
                let locationName = vm.project.locationName ?? ""
                return vm.project.name.lowercased().contains(searchText.lowercased()) || companyName.lowercased().contains(searchText.lowercased()) || locationName.lowercased().contains(searchText.lowercased())
            }
            else {
                return false
            }
        })
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
