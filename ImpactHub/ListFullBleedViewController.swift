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
    @IBOutlet weak var connectContainer: UIView?
    @IBOutlet weak var approveDeclineStackView: UIStackView?

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
            self.shouldHideStatusBar = true
            self.navigationController?.setNavigationBarHidden(true, animated: true)
            // Avoid setting this if it's nil on this contrller, as it'll cause things to animate when we don't want it to
            if connectButtonBottomConsatraint != nil {
                connectButtonBottomConsatraint?.constant = connectButtonBottomConsatraintDefault
                UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseInOut, animations: {
                    self.setNeedsStatusBarAppearanceUpdate()
                    self.view.layoutIfNeeded()
                }) { (_) in
                    
                }
            }
            
        }
        // This will happen when we go back to a previous controller that already was scrolled down a bit...
        else if topMenu?.isShow ?? true {
            self.navigationController?.setNavigationBarHidden(false, animated: false)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseInOut, animations: {
            self.setNeedsStatusBarAppearanceUpdate()
        }) { (_) in
            
        }
        
        self.scrollViewDidScroll(self.collectionView)

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // TODO: Fix this issue with bar hiding when switching tabs
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
            if self.collectionView.contentOffset.y > 50 {
                self.tabBarController?.tabBar.isHidden = false
            }
        }

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        
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
        super.prepare(for: segue, sender: sender)
        if segue.identifier == "ShowCreatePost" {
            if let navVC = segue.destination as? UINavigationController {
                if let vc = navVC.viewControllers.first as? CreatePostViewController, let chatterGroupId = self.chatterGroupId {
                    vc.delegate = self
                    vc.createType = .post(chatterGroupId: chatterGroupId)
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
    func didSendContactRequest() {
    }
    
    var cellWantsToSendContactRequest: MemberCollectionViewCell?

}

extension ListFullBleedViewController: MemberCollectionViewCellDelegate {
    
    func wantsToCreateNewMessage(member: Member) {
        self.performSegue(withIdentifier: "ShowMessageThread", sender: self)
    }
    
    
    func wantsToSendContactRequest(member: Member, cell: MemberCollectionViewCell) {
        self.cellWantsToSendContactRequest = cell
        self.performSegue(withIdentifier: "ShowCreatePostContactMessage", sender: self)
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


