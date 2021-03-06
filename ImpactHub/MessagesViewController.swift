//
//  MessagesViewController.swift
//  ImpactHub
//
//  Created by Niklas Alvaeus on 19/05/2017.
//  Copyright © 2017 Lightful Ltd. All rights reserved.
//

import UIKit
import PromiseKit


class MessagesViewController: UIViewController {
    
    var data = [CellRepresentable]()
    
    @IBOutlet weak var noMessagesLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib.init(nibName: "MessagesCell", bundle: nil), forCellWithReuseIdentifier: MessagesVM.cellIdentifier)

        _ = ContactRequestManager.shared.refresh()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(color: UIColor.white), for: .default)
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.imaGreyishBrown, NSFontAttributeName: UIFont(name:"GTWalsheim", size:18)!]
        self.navigationController?.navigationBar.barStyle = .default
        self.collectionView.alpha = 0
        loadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // If coming from home short cut
        if showContactsOnOpen {
            showContacts()
            showContactsOnOpen = false
        }
    }

    var showContactsOnOpen = false

    func showContacts() {
        showContactsOnOpen = false
        self.performSegue(withIdentifier: "ShowContacts", sender: self)
    }
    
    var selectedVM: MessagesVM?
    
    var skip = 0
    var top = 200
    
    func loadData() {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        firstly {
            APIClient.shared.getConversations()
            }.then { items -> Void in
                if items.isEmpty {
                    self.showNoMessages()
                }
                else {
                    self.hideNoMessages()
                }
                var newData = [CellRepresentable]()
                let cellWidth: CGFloat = self.view.frame.width
                items.forEach({ (conversation) in
                    let viewModel = MessagesVM(conversation: conversation, cellSize: CGSize(width: cellWidth, height: 80))
                    newData.append(viewModel)
                })
                if self.skip == 0 {
                    self.data = newData
                    self.collectionView.alpha = 0
                    self.collectionView.frame = self.collectionView.frame.offsetBy(dx: 0, dy: 20)
                    self.collectionView.reloadData()
                    if self.collectionView.alpha == 0 {
                        UIView.animate(withDuration: 0.5, delay: 0.2, options: .curveEaseInOut, animations: {
                            self.collectionView.alpha = 1
                            self.collectionView.frame = self.collectionView.frame.offsetBy(dx: 0, dy: -20)
                        }, completion: { (_) in
                        })
                    }
                }
                else {
                    self.data.append(contentsOf: newData)
                    var indexes = [IndexPath]()
                    for (index, _) in newData.enumerated() {
                        indexes.append(IndexPath(item: self.top + index - 1, section: 0))
                    }
                    self.collectionView.insertItems(at: indexes)
                }
            }.always {
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            }.catch { error in
                self.showNoMessages()
                debugPrint(error.localizedDescription)
        }
    }
    
    func showNoMessages() {
        self.noMessagesLabel.alpha = 0
        self.noMessagesLabel.isHidden = false
        UIView.animate(withDuration: 0.5, animations: {
            self.noMessagesLabel.alpha = 1
        })
    }

    func hideNoMessages() {
        self.noMessagesLabel.isHidden = true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if segue.identifier == "ShowMessageThread" {
            if let vc = segue.destination as? MessagesThreadViewController, let selectedItem = selectedVM {
                vc.conversation = selectedItem.conversation
            }
        }
    }
    
}

extension MessagesViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return data[indexPath.item].cellInstance(collectionView, indexPath: indexPath)
    }
}

extension MessagesViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let vm = data[indexPath.item] as? MessagesVM {
            selectedVM = vm
            performSegue(withIdentifier: "ShowMessageThread", sender: self)
        }
    }
}

extension MessagesViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return data[indexPath.item].cellSize
        
    }
}
