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
        if isShow {
            return
        }
        isShow = true
        scrollViewTopConstraint.constant = 0
        
        UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseInOut, animations: {
            self.alpha = 1
//            self.layoutIfNeeded()
        }) { (_) in
            
        }
        
    }
    
    func hide() {
        if !isShow {
            return
        }
        isShow = false
//        scrollViewTopConstraint.constant = -self.frame.height
        UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseInOut, animations: {
            self.alpha = 0
//            self.layoutIfNeeded()
        }) { (_) in
            
        }
        

    }
    
    var buttons = [UIButton]()
    var redLine = UIImageView()
    var redLineXConstraint: NSLayoutConstraint!
    var redLineWidthConstraint: NSLayoutConstraint!
    
    func setupWithItems(_ items: [String], gap: CGFloat = 40, leftMargin: CGFloat = 20) {
        
        if items.count == 0 {
            return
        }
        
        var items = items
        buttons.removeAll()
        
        let firstItem = items.removeFirst()
        
        var lastButton: UIButton?
        
        let button = buttonWithTitle(firstItem)
        scrollContentView.addSubview(button)
        button.leadingAnchor.constraint(equalTo: scrollContentView.leadingAnchor, constant: leftMargin).isActive = true
        button.centerYAnchor.constraint(equalTo: scrollContentView.centerYAnchor).isActive = true
        button.tag = 0
        buttons.append(button)
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
            buttons.append(button)
        }
        
        redLine.image = UIImage().createSelectionIndicator(color: UIColor.imaGrapefruit, size: CGSize(width: 10, height: 3), lineWidth: 3.0)
        redLine.contentMode = .scaleToFill
        redLine.translatesAutoresizingMaskIntoConstraints = false
        scrollContentView.addSubview(redLine)
        
        redLineXConstraint = redLine.centerXAnchor.constraint(equalTo: buttons.first!.centerXAnchor, constant: 0)
        redLineXConstraint.isActive = true

        redLineWidthConstraint = buttons.first!.widthAnchor.constraint(equalTo: redLine.widthAnchor, constant: 0)
        redLineWidthConstraint.isActive = true

        redLine.heightAnchor.constraint(equalToConstant: 3).isActive = true
        
        redLine.bottomAnchor.constraint(equalTo: scrollContentView.bottomAnchor, constant: -3).isActive = true
        
        layoutIfNeeded()
        scrollContentWidthConstraint.constant = lastButton!.frame.origin.x + lastButton!.frame.width + 10
    }
    
    func selectButton(index: Int) {
        if index > buttons.count - 1 {
            return
        }
        buttonClicked(sender: buttons[index])
    }
    
    func buttonClicked(sender: UIButton) {
        buttons.forEach { (button) in
            button.isSelected = false
        }
        sender.isSelected = true
        
        redLineXConstraint.isActive = false
        redLineXConstraint = redLine.centerXAnchor.constraint(equalTo: sender.centerXAnchor, constant: 0)
        redLineXConstraint.isActive = true
        
        redLineWidthConstraint.isActive = false
        redLineWidthConstraint = sender.widthAnchor.constraint(equalTo: redLine.widthAnchor, constant: 0)
        redLineWidthConstraint.isActive = true
        
        UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseIn, animations: {
            self.layoutIfNeeded()
        }) { (_) in
            
        }
        
        // If button tapped is outside, scroll it into view...
        if sender.frame.origin.x + sender.frame.size.width > scrollView.frame.width {
            scrollView.setContentOffset(CGPoint(x: sender.frame.origin.x - sender.frame.size.width * 2, y: scrollView.frame.origin.y), animated: true)
        }
        
        self.delegate?.topMenuDidSelectIndex(sender.tag)
    }
    
    func buttonWithTitle(_ title: String) -> UIButton {
        let button = UIButton()
        button.setTitleColor(UIColor.imaSilver, for: .normal)
        button.setTitleColor(UIColor.imaSilver, for: .highlighted)
        button.setTitleColor(UIColor.imaGreyishBrown, for: .selected)
        button.setTitle(title, for: .normal)
        button.setTitle(title, for: .highlighted)
        button.setTitle(title, for: .selected)
        button.titleLabel?.font = UIFont(name: "GTWalsheim", size: 12.5)
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
