//
//  CompaniesViewController.swift
//  ImpactHub
//
//  Created by Niklas on 17/05/2017.
//  Copyright © 2017 Lightful Ltd. All rights reserved.
//

import UIKit
import PromiseKit

class JobsViewController: UIViewController, UITextFieldDelegate {

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
        collectionView.register(UINib.init(nibName: JobViewModel.cellIdentifier, bundle: nil), forCellWithReuseIdentifier: JobViewModel.cellIdentifier)
        
        
        
        let company = Company(id: "dsfsd", name: "Aspite", type: "dsfsdfs", photo: "companyImage", blurb: "Lorem ipsum", locationName: "London, UK", website: "www.bbc.co.uk", size: "10 - 20")
        
        let item1 = Job(id: "zxddz", name: "Marketing Strategist", company: company, description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.", locationName: "London, UK", type: "Fulltime", salary: "€ 30.000 / 40.000 p/a", companyName: "Aspire", companyId: "dsfsdfsdfs")

        
        let cellWidth: CGFloat = self.view.frame.width
        let viewModel1 = JobViewModel(job: item1, cellSize: CGSize(width: cellWidth, height: 145))
        let viewModel2 = JobViewModel(job: item1, cellSize: CGSize(width: cellWidth, height: 145))
        let viewModel3 = JobViewModel(job: item1, cellSize: CGSize(width: cellWidth, height: 145))
        let viewModel4 = JobViewModel(job: item1, cellSize: CGSize(width: cellWidth, height: 145))
        
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
    
    var selectedVM: JobViewModel?
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowJob" {
            if let vc = segue.destination as? JobViewController, let selectedItem = selectedVM {
                vc.job = selectedItem.job
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

extension JobsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return data[indexPath.item].cellInstance(collectionView, indexPath: indexPath)
    }
}

extension JobsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let vm = data[indexPath.item] as? JobViewModel {
            selectedVM = vm
            performSegue(withIdentifier: "ShowJob", sender: self)
        }
    }
}

extension JobsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return data[indexPath.item].cellSize
        
    }
}

extension JobsViewController: UIViewControllerPreviewingDelegate {
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        
        guard let indexPath = collectionView.indexPathForItem(at: location) else { return nil }
        guard let cell = collectionView.cellForItem(at: indexPath) else { return nil }

        var detailVC: UIViewController!

        if let vm = data[indexPath.item] as? JobViewModel {
            selectedVM = vm
            detailVC = storyboard?.instantiateViewController(withIdentifier: "JobViewController")
            (detailVC as! JobViewController).job = selectedVM?.job

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
