//
//  ListWithSearchViewController.swift
//  ImpactHub
//
//  Created by Niklas Alvaeus on 21/06/2017.
//  Copyright © 2017 Lightful Ltd. All rights reserved.
//

import UIKit

class ListWithSearchViewController: UIViewController, UITextFieldDelegate {

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
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
        UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseInOut, animations: {
            self.setNeedsStatusBarAppearanceUpdate()
        }) { (_) in
            
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
