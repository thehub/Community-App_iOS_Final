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
import ReverseExtension


class MessagesThreadViewController: UIViewController {

    @IBOutlet weak var inputTextViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var inputTextView: UITextView!
    
    var placeholderText = "Type Something..."
    
    var data = [TableCellRepresentable]()
    
    var conversation: Conversation? // Will be null if we're creating a new message from Member page for instance
    var member: Member? // If we're creating a new message to
    
    var mentionCompletions = [MentionCompletion]()
    
    var editingMessageText: String?

    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = nil
        tableView.re.delegate = self
        tableView.re.scrollViewDidReachTop = { scrollView in
            print("scrollViewDidReachTop")
        }
        tableView.re.scrollViewDidReachBottom = { scrollView in
            print("scrollViewDidReachBottom")
        }

        loadData()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        registerForKeyboardNotifications()
        
        if let conversation = self.conversation {
            print(SFUserAccountManager.sharedInstance().currentUser!.accountIdentity.userId)
            print(SessionManager.shared.me!.member.userId)
            print(conversation.latestMessage.sender.id)
            print(conversation.latestMessage.recipients.first?.id)
            // Find the other user
            if conversation.latestMessage.sender.id != SessionManager.shared.me!.member.userId {
                self.title = conversation.latestMessage.sender.displayName
            }
            else if conversation.latestMessage.recipients.first?.id != SessionManager.shared.me!.member.userId {
                self.title = conversation.latestMessage.recipients.first?.displayName ?? "Thread"
            }
        }
        else {
            self.title = self.member?.name ?? "Thread"
        }
        
        self.inputTextView.text = placeholderText
        self.navigationController?.setNavigationBarHidden(false, animated: true)
//        self.tabBarController?.tabBar.isHidden = true
        self.viewDidCancel = false
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.inputTextView.becomeFirstResponder()
    }

    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.viewDidCancel = true
        deregisterFromKeyboardNotifications()
    }
    
    var observer1: NSObjectProtocol?
    var observer2: NSObjectProtocol?

    
    func registerForKeyboardNotifications() {
        //Adding notifies on keyboard appearing
        
        
        self.observer1 = NotificationCenter.default.addObserver(forName: NSNotification.Name.UIKeyboardWillShow, object: nil, queue: OperationQueue.main) { (note) in
            self.keyboardWasShown(notification: note)
        }
        
        self.observer2 = NotificationCenter.default.addObserver(forName: NSNotification.Name.UIKeyboardWillHide, object: nil, queue: OperationQueue.main) { (note) in
            self.keyboardWillBeHidden(notification: note)
        }

    }
    
    
    func deregisterFromKeyboardNotifications() {
        if let observer = self.observer1 {
            NotificationCenter.default.removeObserver(observer)
        }
        if let observer = self.observer2 {
            NotificationCenter.default.removeObserver(observer)
        }
    }
    
    func keyboardWasShown(notification: Notification) {
        var info : Dictionary = notification.userInfo!
        if let keyboardSize = (info[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.size {
            // odd behaviour, sometimes the height comes as 0, on second time the view is shown
            if keyboardSize.height == 0 {
                self.bottomConstraint.constant = SessionManager.shared.keyboardHeight + 10
            }
            else {
                SessionManager.shared.keyboardHeight = keyboardSize.height
                self.bottomConstraint.constant = keyboardSize.height + 10
            }
            UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                self.view.layoutIfNeeded()
            }) { (_) in
            }
        }
    }
    
    func keyboardWillBeHidden(notification: Notification?) {
        self.bottomConstraint.constant = 0
        UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
            self.view.layoutIfNeeded()
        }) { (_) in
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    var skip = 0
    var top = 20
    
    var inReplyTo: String?
    
    func loadData() {
        // TODO: User Member as message id here...
        guard let conversationId = self.conversation?.id else {
            return
        }
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        firstly {
            APIClient.shared.getMessagesForConversation(conversationId: conversationId)
            }.then { items -> Void in
                self.inReplyTo = items.last?.id
                var newData = [TableCellRepresentable]()
                let cellWidth: CGFloat = self.view.frame.width
                var previousMessage: Message?
                
                let itemsSorted = items.sorted(by: {$0.sentDate > $1.sentDate})
                
                for (index, message) in itemsSorted.enumerated() {
                    let myUserId = SessionManager.shared.me?.member.userId ?? ""
                    // It's me
                    if message.sender.id == myUserId {
                        if previousMessage?.sender.id != myUserId {
                            // Time stamp
                            let viewModelTime = MessagesThreadMeTimeVM.init(message: message, cellSize: CGSize(width: cellWidth, height: 30))
                            newData.append(viewModelTime)
                        }
                        
                        // Message bubble, with corners depending on position
                        if index + 1 < items.count {
                            let nextItem = items[index + 1]
                            if nextItem.sender.id != myUserId {
                                let viewModel = MessagesThreadMeVM.init(message: message, cellSize: CGSize(width: cellWidth, height: 55), corners: [.topRight, .bottomRight, .bottomLeft])
                                newData.append(viewModel)
                            } else {
                                let viewModel = MessagesThreadMeVM.init(message: message, cellSize: CGSize(width: cellWidth, height: 55), corners: [.topLeft, .topRight, .bottomRight, .bottomLeft])
                                newData.append(viewModel)
                            }
                        }
                        else {
                            let viewModel = MessagesThreadMeVM.init(message: message, cellSize: CGSize(width: cellWidth, height: 55), corners: [.topRight, .bottomRight, .bottomLeft])
                            newData.append(viewModel)
                        }
                        
                        // Picture
                        if index + 1 < items.count {
                            let nextItem = items[index + 1]
                            if nextItem.sender.id != myUserId {
                                let viewModelPic = MessagesThreadMePicVM.init(message: message, cellSize: CGSize(width: cellWidth, height: 30))
                                newData.append(viewModelPic)
                            }
                        }
                        else {
                            let viewModelPic = MessagesThreadMePicVM.init(message: message, cellSize: CGSize(width: cellWidth, height: 30))
                            newData.append(viewModelPic)
                        }
                    }
                    // It's them
                    else {
                        if previousMessage?.sender.id != message.sender.id {
                            // Time stamp
                            let viewModelTime = MessagesThreadThemTimeVM.init(message: message, cellSize: CGSize(width: cellWidth, height: 30))
                            newData.append(viewModelTime)
                        }

                        // Message bubble, with corners depending on position
                        if index + 1 < items.count {
                            let nextItem = items[index + 1]
                            if nextItem.sender.id != message.sender.id {
                                let viewModel = MessagesThreadThemVM.init(message: message, cellSize: CGSize(width: cellWidth, height: 55), corners: [.topLeft, .bottomRight, .bottomLeft])
                                newData.append(viewModel)
                            } else {
                                let viewModel = MessagesThreadThemVM.init(message: message, cellSize: CGSize(width: cellWidth, height: 55), corners: [.topLeft, .topRight, .bottomRight, .bottomLeft])
                                newData.append(viewModel)
                            }
                        }
                        else {
                            let viewModel = MessagesThreadThemVM.init(message: message, cellSize: CGSize(width: cellWidth, height: 55), corners: [.topLeft, .bottomRight, .bottomLeft])
                            newData.append(viewModel)
                        }
                        
                        // Picture
                        if index + 1 < items.count {
                            let nextItem = items[index + 1]
                            if nextItem.sender.id != message.sender.id {
                                let viewModelPic = MessagesThreadThemPicVM.init(message: message, cellSize: CGSize(width: cellWidth, height: 30))
                                newData.append(viewModelPic)
                            }
                        }
                        else {
                            let viewModelPic = MessagesThreadThemPicVM.init(message: message, cellSize: CGSize(width: cellWidth, height: 30))
                            newData.append(viewModelPic)
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
 
    var inTransit = false
    
    func sendPost(text: String) {
        guard let text = self.inputTextView.text else {
            return
        }
        if self.inTransit {
            return
        }
        
        inTransit = true
        
        var members: [Member]?
        if let member = self.member {
            members = [member]
        }
        firstly {
            APIClient.shared.sendMessage(message: text, members: members, inReplyTo: self.inReplyTo)
            }.then { message -> Void in
                print(message)
                // TODO: Insert this without reload.
                self.inputTextView.text = self.placeholderText
                self.loadData()
            }.always {
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                self.inTransit = false
            }.catch { error in
                debugPrint(error.localizedDescription)
                let alert = UIAlertController(title: "Error", message: "Could not send message. Please try again.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
        }
        
    }
    
    var viewDidCancel = false // to prevent textViewShouldEndEditing from being called when going back

}

extension MessagesThreadViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
//        if textView.text == placeholderText {
//            textView.text = nil
//            textView.textColor = UIColor.darkGray   //UIColor(hex: 0xcccccc)
//        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
//        textView.text = nil
    }
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        return true
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        guard let oldText = textView.text else { return true }
        
        if inputTextView.text == placeholderText {
            inputTextView.text = ""
        }
        
        if text == "\n" {
            if inputTextView.text.characters.count == 0 {
                inputTextView.text = placeholderText
            }
            else {
                if inputTextView.text != self.placeholderText && !viewDidCancel {
                    sendPost(text: inputTextView.text)
                }
                else {
                    self.inputTextView.text = self.placeholderText
                    return false
                }
            }
            return false
        }
        
        // Check for urls in text
//        let detector = try! NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
//        let matches = detector.matches(in: textView.text, options: .reportCompletion, range: NSMakeRange(0, textView.text.characters.count))
        
        if textView == inputTextView {
            let newLength = oldText.utf16.count + text.utf16.count - range.length
            // Compnesate for url shortener, each link will be 24 characters
//            matches.forEach { (match) in
//                newLength -= match.range.length
//                newLength += 24
//            }
//            shortTextCounter.text = "\(140 - newLength + 1)"
            return newLength <= 254
        }
        else {
            return true
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
