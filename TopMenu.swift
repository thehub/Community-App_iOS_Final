//
//  TopMenu.swift
//  ImpactHub
//
//  Created by Niklas on 18/05/2017.
//  Copyright © 2017 Lightful Ltd. All rights reserved.
//

import UIKit


protocol TopMenuDelegate: class {
    func topMenuDidSelectIndex(_ index: Int)
}

class TopMenu: UIView {
    @IBOutlet weak var scrollViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var scrollContentWidthConstraint: NSLayoutConstraint!

    weak var delegate: TopMenuDelegate?

    var contentView : UIView?

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var scrollContentView: UIView!
    
    var isShow = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        xibSetup()
    }
    
    func show() {
        
        isShow = true
        scrollViewTopConstraint.constant = 0
        
        UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseInOut, animations: {
            self.alpha = 1
            self.layoutIfNeeded()
        }) { (_) in
            
        }
        
    }
    
    func hide() {
        isShow = false
        scrollViewTopConstraint.constant = -self.frame.height
        UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseInOut, animations: {
            self.alpha = 0
            self.layoutIfNeeded()
        }) { (_) in
            
        }
        

    }
    
    func setupWithItems(_ items: [String], gap: CGFloat = 40, leftMargin: CGFloat = 20) {
        
        if items.count == 0 {
            return
        }
        
        var items = items
        
        let firstItem = items.removeFirst()
        
        var lastButton: UIButton?
        
        let button = buttonWithTitle(firstItem)
        scrollContentView.addSubview(button)
        button.leadingAnchor.constraint(equalTo: scrollContentView.leadingAnchor, constant: leftMargin).isActive = true
        button.centerYAnchor.constraint(equalTo: scrollContentView.centerYAnchor).isActive = true
        button.tag = 0
        button.addTarget(self, action: #selector(self.buttonClicked), for: .touchUpInside)
        lastButton = button
        
        
        for (index, item) in items.enumerated() {
            let button = buttonWithTitle(item)
            scrollContentView.addSubview(button)
            button.leadingAnchor.constraint(equalTo: lastButton!.trailingAnchor, constant: gap).isActive = true
            button.centerYAnchor.constraint(equalTo: scrollContentView.centerYAnchor).isActive = true
            button.tag = index + 1
            button.addTarget(self, action: #selector(self.buttonClicked), for: .touchUpInside)
            lastButton = button
        }
        
        layoutIfNeeded()
        
        scrollContentWidthConstraint.constant = lastButton!.frame.origin.x + lastButton!.frame.width + 10
    }
    
    func buttonClicked(sender: UIButton) {
        self.delegate?.topMenuDidSelectIndex(sender.tag)
    }
    
    func buttonWithTitle(_ title: String) -> UIButton {
        let button = UIButton()
        button.setTitleColor(UIColor.blue, for: .normal)
        button.setTitleColor(UIColor.white, for: .highlighted)
        button.setTitleColor(UIColor.black, for: .selected)
        button.setTitle(title, for: .normal)
        button.setTitle(title, for: .highlighted)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }
    
    
    func xibSetup() {
        guard let view = loadViewFromNib() else { return }
//        view.frame = bounds
//        view.autoresizingMask =
//            [.flexibleWidth, .flexibleHeight]
        addSubview(view)
        
        view.translatesAutoresizingMaskIntoConstraints = false
        view.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        view.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        view.topAnchor.constraint(equalTo: topAnchor).isActive = true
        view.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        contentView = view
        
        contentView?.clipsToBounds = true
        scrollViewTopConstraint.constant = -frame.height
        alpha = 0

    }
    
    func loadViewFromNib() -> UIView? {
//        guard let nibName = nibName else { return nil }
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "TopMenu", bundle: bundle)
        return nib.instantiate(
            withOwner: self,
            options: nil).first as? UIView
    }
    


}
