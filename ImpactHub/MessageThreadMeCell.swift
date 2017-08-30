//
//  MessageThreadMeCell.swift
//  ImpactHub
//
//  Created by Niklas Alvaeus on 06/06/2017.
//  Copyright © 2017 Lightful Ltd. All rights reserved.
//

import UIKit
import SafariServices

class MessageThreadMeCell: UITableViewCell, UITextViewDelegate {

    @IBOutlet weak var messageLabelContainer: UIView!
    @IBOutlet weak var messageLabel: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    let linkAttributes = [ NSFontAttributeName: UIFont(name: "GTWalsheim-Light", size: 14.0)!, NSForegroundColorAttributeName : UIColor.imaSilver]

    func setUp(vm: MessagesThreadMeVM) {
        messageLabel.text = vm.message.text
        messageLabel.linkTextAttributes = linkAttributes
        messageLabel.delegate = self

        // TODO: Where is the draw call for this?
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
            self.messageLabelContainer.round(corners: vm.corners, radius: 20)
        }
        
    }
    
    @available(iOS 10.0, *)
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        let safariVC = SFSafariViewController(url: URL)
        safariVC.preferredBarTintColor = UIColor.imaGrapefruit
        if #available(iOS 11.0, *) {
            safariVC.dismissButtonStyle = .close
        }
        UIApplication.shared.keyWindow?.rootViewController?.present(safariVC, animated: true, completion: nil)
        return false
    }
    
    @available(iOS 9.0, *)
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange) -> Bool {
        let safariVC = SFSafariViewController(url: URL)
        UIApplication.shared.keyWindow?.rootViewController?.present(safariVC, animated: true, completion: nil)
        return false
    }

}
