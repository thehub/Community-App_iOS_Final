//
//  MessagesThreadViewController.swift
//  ImpactHub
//
//  Created by Niklas Alvaeus on 06/06/2017.
//  Copyright © 2017 Lightful Ltd. All rights reserved.
//

import UIKit
import PromiseKit
import SalesforceSDKCore



class MessagesThreadViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var data = [TableCellRepresentable]()
    
    var conversationId: String!
    
    var mentionCompletions = [MentionCompletion]()
    
    var editingMessageText: String?

    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    var skip = 0
    var top = 20
    
    func loadData() {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        firstly {
            
            APIClient.shared.getMessagesForConversation(conversationId: conversationId)
            }.then { items -> Void in
                var newData = [TableCellRepresentable]()
                let cellWidth: CGFloat = self.view.frame.width
                var previousMessage: Message?
                
                for (index, message) in items.enumerated() {
                    let myUserId = "\(SFUserAccountManager.sharedInstance().currentUser!.accountIdentity.userId!)QAS"  // FIXME: User name seems to need QAS appended to it?
                    // It's me
                    if message.sender.id == myUserId {
                        if previousMessage?.sender.id != myUserId {
                            let viewModelPic = MessagesThreadMePicVM.init(message: message, cellSize: CGSize(width: cellWidth, height: 30))
                            newData.append(viewModelPic)
                        }
                        let viewModel = MessagesThreadMeVM.init(message: message, cellSize: CGSize(width: cellWidth, height: 75))
                        newData.append(viewModel)

                        if index + 1 < items.count {
                            let nextItem = items[index + 1]
                            if nextItem.sender.id != myUserId {
                                // Time stamp
                                let viewModelTime = MessagesThreadMeTimeVM.init(message: message, cellSize: CGSize(width: cellWidth, height: 30))
                                newData.append(viewModelTime)
                            }
                        }
                        else {
                            // Time stamp
                            let viewModelTime = MessagesThreadMeTimeVM.init(message: message, cellSize: CGSize(width: cellWidth, height: 30))
                            newData.append(viewModelTime)
                        }
                        
                    }
                    // It's them
                    else {
                        if previousMessage?.sender.id != message.sender.id {
                            let viewModelPic = MessagesThreadThemPicVM.init(message: message, cellSize: CGSize(width: cellWidth, height: 30))
                            newData.append(viewModelPic)
                        }
                        let viewModel = MessagesThreadThemVM.init(message: message, cellSize: CGSize(width: cellWidth, height: 75))
                        newData.append(viewModel)
                        
                        if index + 1 < items.count {
                            let nextItem = items[index + 1]
                            if nextItem.sender.id != message.sender.id {
                                // Time stamp
                                let viewModelTime = MessagesThreadThemTimeVM.init(message: message, cellSize: CGSize(width: cellWidth, height: 30))
                                newData.append(viewModelTime)
                            }
                        }
                        else {
                            // Time stamp
                            let viewModelTime = MessagesThreadThemTimeVM.init(message: message, cellSize: CGSize(width: cellWidth, height: 30))
                            newData.append(viewModelTime)
                        }

                    }
                    previousMessage = message
                }
                if self.skip == 0 {
                    self.data = newData
                    self.tableView.alpha = 0
                    self.tableView.frame = self.tableView.frame.offsetBy(dx: 0, dy: 20)
                    self.tableView.reloadData()
                    if self.tableView.alpha == 0 {
                        UIView.animate(withDuration: 0.5, delay: 0.2, options: .curveEaseInOut, animations: {
                            self.tableView.alpha = 1
                            self.tableView.frame = self.tableView.frame.offsetBy(dx: 0, dy: -20)
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
                    self.tableView.insertRows(at: indexes, with: .bottom)
                }
            }.always {
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            }.catch { error in
                debugPrint(error.localizedDescription)
        }
    }
    
}

extension MessagesThreadViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return data[indexPath.item].cellInstance(tableView, indexPath: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return data[indexPath.item].cellSize.height
    }
}

extension MessagesThreadViewController: UITableViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        print("scrollView.contentOffset.y =", scrollView.contentOffset.y)
    }
}
