//
//  CompaniesViewController.swift
//  ImpactHub
//
//  Created by Niklas on 17/05/2017.
//  Copyright © 2017 Lightful Ltd. All rights reserved.
//

import UIKit
import PromiseKit

class ProjectsViewController: UIViewController, UITextFieldDelegate {

    var data = [CellRepresentable]()

    
    @IBOutlet weak var collectionView: UICollectionView!

    @IBOutlet weak var searchContainerTopConstraint: NSLayoutConstraint!
    var searchContainerTopConstraintDefault: CGFloat = 0

    @IBOutlet weak var searchInputTextField: UITextField!
    @IBOutlet weak var filterButton: UIButton!
    
    @IBOutlet weak var searchContainer: UIView!
    @IBOutlet weak var searchTextBg: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if(traitCollection.forceTouchCapability == .available){
            registerForPreviewing(with: self, sourceView: self.collectionView)
        }
        
        self.searchContainerTopConstraintDefault = searchContainerTopConstraint.constant
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib.init(nibName: ProjectViewModel.cellIdentifier, bundle: nil), forCellWithReuseIdentifier: ProjectViewModel.cellIdentifier)
        
//        let item1 = Member(name: "Niklas", job: "Developer", photo: "photo", blurb: "Lorem ipsum dolor sit amet, habitasse a suspendisse et, nec suscipit imperdiet sed, libero mollis felis egestas vivamus velit, felis velit interdum phasellus luctus, nulla molestie felis ligula diam.", aboutMe: "Lorem ipsum dolor sit amet, habitasse a suspendisse et, nec suscipit imperdiet sed, libero mollis felis egestas vivamus velit, felis velit interdum phasellus luctus, nulla molestie felis ligula diam. Lorem ipsum dolor sit amet, habitasse a suspendisse et, nec suscipit imperdiet sed, libero mollis felis egestas vivamus velit, felis velit interdum phasellus luctus, nulla molestie felis ligula diam. Lorem ipsum dolor sit amet, habitasse a suspendisse et, nec suscipit imperdiet sed, libero mollis felis egestas vivamus velit, felis velit interdum phasellus luctus, nulla molestie felis ligula diam.", locationName: "London")
//        let item2 = Member(name: "Neela", job: "Salesforce", photo: "photo", blurb: "Lorem ipsum dolor sit amet, habitasse a suspendisse et, nec suscipit imperdiet sed, libero mollis felis egestas vivamus velit, felis velit interdum phasellus luctus, nulla molestie felis ligula diam.", aboutMe: "Lorem ipsum dolor sit amet, habitasse a suspendisse et, nec suscipit imperdiet sed, libero mollis felis egestas vivamus velit, felis velit interdum phasellus luctus, nulla molestie felis ligula diam.", locationName: "London")
//        let item3 = Member(name: "Russel", job: "Salesforce", photo: "photo", blurb: "Lorem ipsum dolor sit amet, habitasse a suspendisse et, nec suscipit imperdiet sed, libero mollis felis egestas vivamus velit, felis velit interdum phasellus luctus, nulla molestie felis ligula diam.", aboutMe: "Lorem ipsum dolor sit amet, habitasse a suspendisse et, nec suscipit imperdiet sed, libero mollis felis egestas vivamus velit, felis velit interdum phasellus luctus, nulla molestie felis ligula diam.", locationName: "London")
//        let item4 = Member(name: "Rob", job: "UX", photo: "photo", blurb: "Lorem ipsum dolor sit amet, habitasse a suspendisse et, nec suscipit imperdiet sed, libero mollis felis egestas vivamus velit, felis velit interdum phasellus luctus, nulla molestie felis ligula diam.", aboutMe: "Lorem ipsum dolor sit amet, habitasse a suspendisse et, nec suscipit imperdiet sed, libero mollis felis egestas vivamus velit, felis velit interdum phasellus luctus, nulla molestie felis ligula diam.", locationName: "London")

        
        let item1 = Project(name: "Zero to one: new startups and Innovative Ideas")
        let item2 = Project(name: "Zero to one: new startups and Innovative Ideas")
        let item3 = Project(name: "Zero to one: new startups and Innovative Ideas")
        let item4 = Project(name: "Zero to one: new startups and Innovative Ideas")
        
        
        let cellWidth: CGFloat = self.view.frame.width
        let viewModel1 = ProjectViewModel(project: item1, cellSize: CGSize(width: cellWidth, height: 370))
        let viewModel2 = ProjectViewModel(project: item2, cellSize: CGSize(width: cellWidth, height: 370))
        let viewModel3 = ProjectViewModel(project: item3, cellSize: CGSize(width: cellWidth, height: 370))
        let viewModel4 = ProjectViewModel(project: item4, cellSize: CGSize(width: cellWidth, height: 370))
        
        self.data.append(viewModel1)
        self.data.append(viewModel2)
        self.data.append(viewModel3)
        self.data.append(viewModel4)

        self.data.append(viewModel1)
        self.data.append(viewModel2)
        self.data.append(viewModel3)
        self.data.append(viewModel4)

        self.data.append(viewModel1)
        self.data.append(viewModel2)
        self.data.append(viewModel3)
        self.data.append(viewModel4)

        
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    var selectedVM: ProjectViewModel?
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowProject" {
            if let vc = segue.destination as? ProjectViewController, let selectedItem = selectedVM {
                vc.project = selectedItem.project
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.searchTextBg.layer.shadowColor = UIColor(hexString: "D5D5D5").cgColor
        self.searchTextBg.layer.shadowOffset = CGSize(width: 0, height: 5)
        self.searchTextBg.layer.shadowOpacity = 0.37
        self.searchTextBg.layer.shadowPath = UIBezierPath(rect: self.searchTextBg.bounds).cgPath
        self.searchTextBg.layer.shadowRadius = 15.0

    }
    
    var lastScrollPositionY: CGFloat = 0
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let currentPositionY = scrollView.contentOffset.y

        if currentPositionY < 0 {
            return
        }
        
        // Scrolling down
        if lastScrollPositionY < currentPositionY {
            let newPosition = searchContainerTopConstraintDefault - currentPositionY
            if newPosition > -100 {
                self.searchContainerTopConstraint.constant = newPosition
            }
            else {
                self.searchContainerTopConstraint.constant = -100
            }
        }
        // Scrolling up
        else {
            let diff = currentPositionY - lastScrollPositionY
            var newPosition = searchContainerTopConstraint.constant - diff
            if newPosition > searchContainerTopConstraintDefault {
                newPosition = searchContainerTopConstraintDefault
            }
            searchContainerTopConstraint.constant = newPosition
        }
        
        lastScrollPositionY = scrollView.contentOffset.y
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.searchInputTextField {
            textField.resignFirstResponder()
        }
        return false
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        
        let newLength = text.utf16.count + string.utf16.count - range.length
        return newLength <= 200
    }
    
}

extension ProjectsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return data[indexPath.item].cellInstance(collectionView, indexPath: indexPath)
    }
}

extension ProjectsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let vm = data[indexPath.item] as? ProjectViewModel {
            selectedVM = vm
            performSegue(withIdentifier: "ShowProject", sender: self)
        }
    }
}

extension ProjectsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let cellWidth: CGFloat = self.collectionView.frame.width
        let width = ((cellWidth - 40) / 1.6)
        let heightToUse = width + 155
        return CGSize(width: view.frame.width, height: heightToUse)
        
    }
}

extension ProjectsViewController: UIViewControllerPreviewingDelegate {
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        
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
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        show(viewControllerToCommit, sender: self)
    }
    
}