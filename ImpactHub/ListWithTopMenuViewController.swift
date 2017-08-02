//
//  ListWithTopMenuViewController.swift
//  ImpactHub
//
//  Created by Niklas Alvaeus on 22/06/2017.
//  Copyright © 2017 Lightful Ltd. All rights reserved.
//

import UIKit

class ListWithTopMenuViewController: UIViewController, TopMenuDelegate {

    var filters = [Filter]()
    
    var filterSource :FilterManager.Source {
        get {
            return FilterManager.Source.members
        }
    }

    var data = [CellRepresentable]()
    @IBOutlet weak var topMenu: TopMenu?

    @IBOutlet weak var collectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()

        
        topMenu?.delegate = self
        
        topMenu?.show()

        if(traitCollection.forceTouchCapability == .available){
            registerForPreviewing(with: self, sourceView: self.collectionView)
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        
        guard let topMenu = self.topMenu else {
            return
        }
        
        let currentPositionY = scrollView.contentOffset.y
        
        if currentPositionY < 0 {
            return
        }
        
        // Scrolling down
        if lastScrollPositionY < currentPositionY {
            topMenu.hide()
        }
            // Scrolling up
        else {
            let diff = currentPositionY - lastScrollPositionY
            if abs(diff) > 5 {
                topMenu.show()
            }
        }
        
        lastScrollPositionY = scrollView.contentOffset.y
    }
    
    func topMenuDidSelectIndex(_ index: Int) {
        
        
    }

}


extension ListWithTopMenuViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return data[indexPath.item].cellInstance(collectionView, indexPath: indexPath)
    }
}

extension ListWithTopMenuViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return data[indexPath.item].cellSize
        
    }
}

extension ListWithTopMenuViewController: UIViewControllerPreviewingDelegate {
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        
        return nil
        
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        show(viewControllerToCommit, sender: self)
    }
}
