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
    @IBOutlet weak var placeholderTextView: UITextView!
    
    
    var data = [TableCellRepresentable]()
    
    var conversation: Conversation? // Will be null if we're creating a new message from Member page for instance
    var conversationId: String? // If comming from push
    var member: Member? // If we're creating a new message to
    
    var mentionCompletions = [MentionCompletion]()
    
    var editingMessageText: String?

    @available(iOS 10.0, *)
    var generatorNotification: UINotificationFeedbackGenerator {
        return UINotificationFeedbackGenerator()
    }
    
    @available(iOS 10.0, *)
    var generatorImpact: UIImpactFeedbackGenerator {
        return UIImpactFeedbackGenerator(style: .light)
    }

    
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

    
    var lastMessage : Message? {
        get {
            var lastMessage = self.conversation?.latestMessage
            // If coming from push we get this once all messages has been loaded...
            if lastMessage == nil {
                lastMessage = self.messages.last
            }
            return lastMessage
        }
    }
    
    var observer: NSObjectProtocol?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        registerForKeyboardNotifications()

        // Store this so we know not to show push if we're looking at the same conversation already.
        
        if let conversation = self.conversation {
            SessionManager.shared.currentlyShowingConversationId = conversation.id
        }
        else {
            SessionManager.shared.currentlyShowingConversationId = self.conversationId
        }
        
        self.title = self.lastMessage?.otherUser().displayName ?? "Message"
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.viewDidCancel = false
        
        // If we get a push for this conversation, refresh
        self.observer = NotificationCenter.default.addObserver(forName: Notification.Name.refreshConversation, object: nil, queue: OperationQueue.main) { (note) in
            if #available(iOS 10.0, *) {
                self.generatorImpact.impactOccurred()
            }
            self.loadData()
        }
        
        if #available(iOS 10.0, *) {
            generatorNotification.prepare()
            generatorImpact.prepare()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        SessionManager.shared.currentlyShowingConversationId = nil
        
        if let observer = self.observer {
            NotificationCenter.default.removeObserver(observer)
        }
        
    }
    
    deinit {
        SessionManager.shared.currentlyShowingConversationId = nil
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
        if let keyboardSize = (info[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.size {
            self.bottomConstraint.constant = keyboardSize.height + 10
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
    var messages = [Message]()
    
    func loadData() {
        // If coming from push we hav conversationId otherwise we have conversation
        if let conversation = self.conversation {
            self.conversationId = conversation.id
        }
        guard let conversationId = self.conversationId else {
            return
        }
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        firstly {
            APIClient.shared.getMessagesForConversation(conversationId: conversationId)
            }.then { items -> Void in
                self.messages = items
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
                    // Set again since it might have been empty first time if coming from a push
                    self.title = self.lastMessage?.otherUser().displayName ?? "Message"
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
            }.then {
                APIClient.shared.markConversationAsRead(conversationId: conversationId)
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
//                if #available(iOS 10.0, *) {
//                    self.generatorNotification.notificationOccurred(.success)
//                }
                // TODO: Insert this without reload.
                self.inputTextView.text = nil
                self.placeholderTextView.isHidden = false
                // If we're creating a new message coming from a member, just pop now.
                if self.member != nil {
                    self.navigationController?.popViewController(animated: true)
                }
                else {
                    self.loadData()
                }
                _ = APIClient.shared.sendPush(fromUserId: SessionManager.shared.me?.member.userId ?? "", toUserIds: self.lastMessage?.otherUser().id ?? "", pushType: .privateMessage(conversationId: message.conversationId ?? ""), relatedId: message.conversationId ?? "")
            }.always {
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                self.inTransit = false
            }.catch { error in
                debugPrint(error.localizedDescription)
                if #available(iOS 10.0, *) {
                    self.generatorNotification.notificationOccurred(.error)
                }
                let alert = UIAlertController(title: "Error", message: "Could not send message. Please try again.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
        }
        
    }
    
    var viewDidCancel = false // to prevent textViewShouldEndEditing from being called when going back


    var selectedUserId: String?
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: self)
        if segue.identifier == "ShowMember" {
            if let vc = segue.destination as? MemberViewController, let userId = selectedUserId {
                vc.userId = userId
            }
        }
    }
    
}

extension MessagesThreadViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == nil {
            self.placeholderTextView.isHidden = false
        }
    }
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        return true
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        guard let oldText = textView.text else { return true }
        
        if text == "\n" {
            if inputTextView.text.characters.count == 0 {
                inputTextView.text = nil
                self.placeholderTextView.isHidden = false
            }
            else {
                if inputTextView.text != " "  && !viewDidCancel {
                    sendPost(text: inputTextView.text)
                }
                else {
                    self.inputTextView.text = nil
                    self.placeholderTextView.isHidden = false
                    return false
                }
            }
            return false
        }
        
        if textView == inputTextView {
            self.placeholderTextView.isHidden = true
            let newLength = oldText.utf16.count + text.utf16.count - range.length
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
        let cellWidth = tableView.frame.width - 110
        
        if let vm = data[indexPath.item] as? MessagesThreadMeVM {
            let height = vm.message.text.height(withConstrainedWidth: cellWidth, font:UIFont(name: "GTWalsheim-Light", size: 16)!) + 40 // add extra height for the standard elements, titles, lines, sapcing etc.
            return height
        }
        else if let vm = data[indexPath.item] as? MessagesThreadThemVM {
            let height = vm.message.text.height(withConstrainedWidth: cellWidth, font:UIFont(name: "GTWalsheim-Light", size: 16)!) + 40 // add extra height for the standard elements, titles, lines, sapcing etc.
            return height
        }
        else {
            return data[indexPath.item].cellSize.height
        }

    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vm = data[indexPath.item] as? MessagesThreadThemPicVM {
            selectedUserId = vm.message.sender.id
            performSegue(withIdentifier: "ShowMember", sender: self)
        }
        else if let vm = data[indexPath.item] as? MessagesThreadMePicVM {
            selectedUserId = vm.message.sender.id
            performSegue(withIdentifier: "ShowMember", sender: self)
        }

    }
    
}

extension MessagesThreadViewController: UITableViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
    }
}
