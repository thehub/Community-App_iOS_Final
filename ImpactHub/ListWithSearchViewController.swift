//
//  ListWithSearchViewController.swift
//  ImpactHub
//
//  Created by Niklas Alvaeus on 21/06/2017.
//  Copyright © 2017 Lightful Ltd. All rights reserved.
//

import UIKit

class ListWithSearchViewController: UIViewController, UITextFieldDelegate, TopMenuDelegate, UISearchBarDelegate, FilterManagerSource {

    var filters = [Filter]()

    @IBOutlet weak var searchBar: UISearchBar?
    
    var filterSource :FilterManager.Source {
        get {
            return FilterManager.Source.members
        }
    }

    var data = [CellRepresentable]()
    var dataAll = [CellRepresentable]()

    @IBOutlet weak var topMenu: TopMenu?
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var searchContainerTopConstraint: NSLayoutConstraint!
    var searchContainerTopConstraintDefault: CGFloat = 0
    
    @IBOutlet weak var searchInputTextField: UITextField!
    @IBOutlet weak var filterButton: UIButton!
    
    @IBOutlet weak var searchContainer: UIView!
    @IBOutlet weak var filterTickImageView: UIImageView?
    @IBOutlet weak var searchTextBg: UIView!

    
    override func viewDidLoad() {
        super.viewDidLoad()

        if(traitCollection.forceTouchCapability == .available){
            registerForPreviewing(with: self, sourceView: self.collectionView)
        }
        
        topMenu?.delegate = self
        
        topMenu?.show()

        self.searchContainerTopConstraintDefault = searchContainerTopConstraint.constant
        
        self.searchBar?.delegate = self
        
    }
    
    func showFilterTick() {
        if !(self.filterTickImageView?.isHidden ?? true) {
            return
        }
        self.filterTickImageView?.transform = CGAffineTransform.init(scaleX: 0.01, y: 0.01)
        self.filterTickImageView?.isHidden = false
        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseOut, animations: { 
            self.filterTickImageView?.transform = CGAffineTransform.identity
        }) { (_) in
        }
    }
    
    func hideFilterTick() {
        if (self.filterTickImageView?.isHidden ?? false) {
            return
        }
        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseOut, animations: {
            self.filterTickImageView?.transform = CGAffineTransform.init(scaleX: 0.01, y: 0.01)
        }) { (_) in
            self.filterTickImageView?.isHidden = true
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.searchTextBg.layer.shadowColor = UIColor(hexString: "D5D5D5").cgColor
        self.searchTextBg.layer.shadowOffset = CGSize(width: 0, height: 5)
        self.searchTextBg.layer.shadowOpacity = 0.37
        self.searchTextBg.layer.shadowPath = UIBezierPath(rect: self.searchTextBg.bounds).cgPath
        self.searchTextBg.layer.shadowRadius = 15.0
        
        let collectionViewLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout
        collectionViewLayout?.sectionInset = UIEdgeInsetsMake(self.searchContainer.frame.height, 0, 60, 0)
        collectionViewLayout?.invalidateLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        updateFilters(filters: FilterManager.shared.getCurrentFilters(source: self.filterSource))

        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
        UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseInOut, animations: {
            self.setNeedsStatusBarAppearanceUpdate()
        }) { (_) in
            
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: self)
        if segue.identifier == "ShowFilter" {
            if let navVC = segue.destination as? UINavigationController {
                if let vc = navVC.viewControllers.first as? FilterViewController {
                    FilterManager.shared.currenttlySelectingFor = self.filterSource
                    vc.delegate = self
                }
            }
        }
    }

    
    var shouldHideStatusBar = false
    
    override var prefersStatusBarHidden: Bool {
        return shouldHideStatusBar
    }
    
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return .slide
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
            if newPosition > -searchContainer.frame.height {
                self.searchContainerTopConstraint.constant = newPosition
            }
            else {
                self.searchContainerTopConstraint.constant = -searchContainer.frame.height
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

    func topMenuDidSelectIndex(_ index: Int) {
        
        
    }
    
    
    // MARK: Search
    // Implemented in respective child class
    func filterContentForSearchText(dataToFilter: [CellRepresentable], searchText:String) -> [CellRepresentable] {
        return []
    }

    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // user did type something, check our datasource for text that looks the same
        applySearchAndFilter(searchText: searchText)
    }

    func applySearchAndFilter(searchText: String) {
        if searchText.characters.count > 0 {
            // search and reload data source
            let dataFiltered = self.filterData(dataToFilter: self.dataAll)
            self.data = self.filterContentForSearchText(dataToFilter: dataFiltered, searchText: searchText)
            self.collectionView?.reloadData()
        }
        else {
            // if text lenght == 0
            // we will consider the searchbar is not active
            let dataFiltered = self.filterData(dataToFilter: self.dataAll)
            self.data = dataFiltered
            self.collectionView?.reloadData()
        }
        
    }
    
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.cancelSearching()
        self.collectionView?.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.view.endEditing(true)
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        //        self.searchBar!.setShowsCancelButton(true, animated: true)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        // this method is being called when search btn in the keyboard tapped
        // we set searchBarActive = NO
        // but no need to reloadCollectionView
        self.searchBar!.setShowsCancelButton(false, animated: false)
    }
    func cancelSearching(){
        self.view.endEditing(true)
        self.searchBar?.resignFirstResponder()
        self.searchBar?.text = ""
    }
    
    // Implemented in respective child class
    func filterData(dataToFilter: [CellRepresentable]) -> [CellRepresentable] {
        return []
    }
    
    
}

extension ListWithSearchViewController: FilterableDelegate {
    func updateFilters(filters: [Filter]) {
        self.filters = filters
        if filters.count > 0 {
            showFilterTick()
        }
        else {
            hideFilterTick()
        }
        
        self.applySearchAndFilter(searchText: self.searchBar?.text ?? "")
    }
}

extension ListWithSearchViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return data[indexPath.item].cellInstance(collectionView, indexPath: indexPath)
    }
}

extension ListWithSearchViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return data[indexPath.item].cellSize
        
    }
}

extension ListWithSearchViewController: UIViewControllerPreviewingDelegate {
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        
        return nil
        
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        show(viewControllerToCommit, sender: self)
    }
}
