//
//  ListFullBleedViewController.swift
//  ImpactHub
//
//  Created by Niklas Alvaeus on 21/06/2017.
//  Copyright © 2017 Lightful Ltd. All rights reserved.
//

import UIKit

class ListFullBleedViewController: UIViewController, UICollectionViewDelegate, TopMenuDelegate, UICollectionViewDelegateFlowLayout, UIGestureRecognizerDelegate, CreatePostViewControllerDelegate {

    @IBOutlet weak var topMenu: TopMenu?
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var connectButtonBottomConsatraint: NSLayoutConstraint?
    var connectButtonBottomConsatraintDefault: CGFloat = 0
    @IBOutlet weak var connectButton: UIButton?

    var data = [CellRepresentable]()

    var chatterGroupId: String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.interactivePopGestureRecognizer?.delegate = self

        if(traitCollection.forceTouchCapability == .available){
            registerForPreviewing(with: self, sourceView: self.collectionView)
        }

        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
        
        topMenu?.delegate = self

    
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.tabBarController?.tabBar.isHidden = true

        
        
        UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseInOut, animations: {
            self.setNeedsStatusBarAppearanceUpdate()
        }) { (_) in
            
        }

    }
    
    var didLayout = false
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if !didLayout {
            didLayout = true
            connectButtonBottomConsatraintDefault = connectButtonBottomConsatraint?.constant ?? 0
        }
    }
    
    func hideConnectButton() {
        self.connectButton?.isHidden = true
    }
    
    func showConnectButton() {
        self.connectButton?.isHidden = false
    }

    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y > 200 && !(topMenu?.isShow ?? false) {
            topMenu?.show()
            self.tabBarController?.tabBar.isHidden = false
            self.shouldHideStatusBar = false
            self.navigationController?.setNavigationBarHidden(false, animated: true)
            connectButtonBottomConsatraint?.constant = connectButtonBottomConsatraintDefault + self.navigationController!.navigationBar.frame.height
            UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseInOut, animations: {                self.setNeedsStatusBarAppearanceUpdate()
                self.view.layoutIfNeeded()
            }) { (_) in
                
            }
            
        }
        else if scrollView.contentOffset.y < 200 && (topMenu?.isShow ?? true) {
            topMenu?.hide()
            self.tabBarController?.tabBar.isHidden = true
            connectButtonBottomConsatraint?.constant = connectButtonBottomConsatraintDefault
            self.shouldHideStatusBar = true
            self.navigationController?.setNavigationBarHidden(true, animated: true)
            
            UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseInOut, animations: {
                self.setNeedsStatusBarAppearanceUpdate()
                self.view.layoutIfNeeded()
            }) { (_) in
                
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        
        
        //        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        //        self.navigationController?.navigationBar.shadowImage = UIImage()
        //        self.navigationController?.navigationBar.isTranslucent = true
        //        self.navigationController?.view.backgroundColor = UIColor.clear
        //        self.navigationController?.navigationBar.backgroundColor = UIColor.clear
        //
        //
        //
        //        self.navigationController?.navigationBar.layer.borderColor = UIColor.clear.cgColor
        //        self.navigationController?.navigationBar.layer.borderWidth = 0
        //        self.navigationController?.navigationBar.layer.shadowColor = UIColor.clear.cgColor
        //        self.navigationController?.navigationBar.layer.shadowOffset = CGSize.zero
        //        self.navigationController?.navigationBar.layer.shadowRadius = 0
        //        self.navigationController?.navigationBar.layer.shadowOpacity = 0
        //        self.navigationController?.navigationBar.layer.masksToBounds = true
        
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        //        self.navigationController?.navigationBar.shadowImage = nil
        
    }

    
    var shouldHideStatusBar = true
    
    override var prefersStatusBarHidden: Bool {
        return shouldHideStatusBar
    }
    
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return .slide
    }
    
    func topMenuDidSelectIndex(_ index: Int) {
        

    }
    
    var postToShowCommentsFor: Post?

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: self)
        if segue.identifier == "ShowCreatePost" {
            if let navVC = segue.destination as? UINavigationController {
                if let vc = navVC.viewControllers.first as? CreatePostViewController {
                    vc.delegate = self
                    vc.chatterGroupId = self.chatterGroupId
                }
            }
        }
        else if segue.identifier == "ShowComments" {
            if let vc = segue.destination as? CommentsViewController, let post = self.postToShowCommentsFor {
                vc.post = post
            }
        }
    }
    
    func didCreatePost(post: Post) {
    }
    
    func didCreateComment(comment: Comment) {
    }
}

extension ListFullBleedViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = data[indexPath.item].cellInstance(collectionView, indexPath: indexPath)
        return cell
    }
}

extension ListFullBleedViewController: UIViewControllerPreviewingDelegate {
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        
        return nil
        
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        show(viewControllerToCommit, sender: self)
    }
}


