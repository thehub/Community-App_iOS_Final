// SessionManager.swift


import Foundation

class SessionManager {
    static let shared = SessionManager()
    
    var me: Me?
    
    var hubs = [Hub]()
    
    var pushNotification: PushNotification?
    
    // Used to avoid showing push if user is already lookin at conversation. Will send refresh notification instead.
    var currentlyShowingConversationId: String?
    
    private init () { }

}
