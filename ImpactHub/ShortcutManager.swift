//
//  ShortcutManager.swift
//  LightfulAdmin
//
//  Created by Niklas Alvaeus on 10/11/2016.
//  Copyright © 2016 Lightful Ltd. All rights reserved.
//

import Foundation
import UIKit



enum ShortcutIdentifier: String {
    case search
    case contacts
    
    func title() -> String {
        switch self {
        case .search:
            return "Search"
        case .contacts:
            return "Contacts"
        }
    }
    
    
    init?(fullType: String) {
        guard let last = fullType.components(separatedBy: ".").last else { return nil }
        
        self.init(rawValue: last)
    }
    
    var type: String {
        return Bundle.main.bundleIdentifier! + ".\(self.rawValue)"
    }
}


class ShortcutManager {

    var showSearchLaunch = false
    var showContactsLaunch = false

    func updateHomeShortCuts() {
        clearHomeShortCuts()
        
        var shortcuts:[UIMutableApplicationShortcutItem] = []
        
        let shortcut = UIMutableApplicationShortcutItem(type: ShortcutIdentifier.search.type, localizedTitle: ShortcutIdentifier.search.title(), localizedSubtitle: nil, icon: UIApplicationShortcutIcon(type: .search), userInfo: nil)
        shortcuts.append(shortcut)

        let shortcut2 = UIMutableApplicationShortcutItem(type: ShortcutIdentifier.contacts.type, localizedTitle: ShortcutIdentifier.contacts.title(), localizedSubtitle: nil, icon: UIApplicationShortcutIcon(type: .contact), userInfo: nil)
        shortcuts.append(shortcut2)

        if shortcuts.count > 0 {
            UIApplication.shared.shortcutItems = shortcuts
        }
    }

    func clearHomeShortCuts() {
        UIApplication.shared.shortcutItems = nil
    }
    
    func handleShortCutItem(_ shortcutItem: UIApplicationShortcutItem) -> Bool {
        var handled = false
        
        // Verify that the provided `shortcutItem`'s `type` is one handled by the application.
        guard ShortcutIdentifier(fullType: shortcutItem.type) != nil else { return false }
        
        guard let shortCutType = shortcutItem.type as String? else { return false }
        
        switch (shortCutType) {
        case ShortcutIdentifier.search.type:
            handled = true
            ShortcutManager.shared.showSearchLaunch = true // for cold start
            NotificationCenter.default.post(name: .onHandleHomeShortCutSearch, object: nil, userInfo: shortcutItem.userInfo)
            break
        case ShortcutIdentifier.contacts.type:
            handled = true
            ShortcutManager.shared.showContactsLaunch = true // for cold start
            NotificationCenter.default.post(name: .onHandleHomeShortCutContacts, object: nil, userInfo: shortcutItem.userInfo)
            break
        default:
            break
        }
        
        
        return handled
    }
    
    
    static let shared = ShortcutManager()

    
}
