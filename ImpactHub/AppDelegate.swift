//
//  AppDelegate.swift
//  ImpactHub
//
//  Created by Niklas on 17/05/2017.
//  Copyright © 2017 Lightful Ltd. All rights reserved.
//

import UIKit
import SalesforceSDKCore

let RemoteAccessConsumerKey = "3MVG9HxRZv05HarR3qV4noRd_eWhwjootRcxv5EGAXfhwC89aYzX47dwhWh0j5yLzUbbSKvVvUZqPuVh.6qB2";
let OAuthRedirectURI        = "lightfulapp://auth/success";

// community-impacthub.cs88.force.com

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    override init() {
        super.init()
        SFLogger.shared().logLevel = .debug
        
        SalesforceSDKManager.shared().connectedAppId = RemoteAccessConsumerKey
        SalesforceSDKManager.shared().connectedAppCallbackUri = OAuthRedirectURI
        SalesforceSDKManager.shared().authScopes = ["web", "api"];
        
        SalesforceSDKManager.shared().postLaunchAction = {
            [unowned self] (launchActionList: SFSDKLaunchAction) in
            
            
            SalesforceSDKManager.shared()
            
            //            let userAccount = SFUserAccountManager.sharedInstance().activeUserIdentity
            //            debugPrint(userAccount?.userId.description)
            
            let launchActionString = SalesforceSDKManager.launchActionsStringRepresentation(launchActionList)
            self.log(.info, msg:"Post-launch: launch actions taken: \(launchActionString)");
            
            if launchActionList.contains(SFSDKLaunchAction.alreadyAuthenticated) {
                SFPushNotificationManager.sharedInstance().registerForRemoteNotifications()
                NotificationCenter.default.post(name: .onLogin, object: nil, userInfo: nil)
            }
            else {
                SFPushNotificationManager.sharedInstance().registerForRemoteNotifications()
                //            self.setupRootViewController();
                NotificationCenter.default.post(name: .onLogin, object: nil, userInfo: nil)
            }
            
        }
        
        
        SalesforceSDKManager.shared().launchErrorAction = {
            [unowned self] (error: Any, launchActionList: Any) in
            if let actualError = error as? NSError {
                self.log(.error, msg:"Error during SDK launch: \(actualError.localizedDescription)")
            } else {
                self.log(.error, msg:"Unknown error during SDK launch.")
            }
            //            self.initializeAppViewState()
            SalesforceSDKManager.shared().launch()
        }
        
        SalesforceSDKManager.shared().postLogoutAction = {
            [unowned self] in
            self.handleSdkManagerLogout()
        }
        
        //        SalesforceSDKManager.shared().switchUserAction = {
        //            [unowned self] (fromUser: SFUserAccount?, toUser: SFUserAccount?) -> () in
        //            self.handleUserSwitch(fromUser, toUser: toUser)
        //        }
    }
 

    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        stylize()
        
        let loginViewController = SFLoginViewController.sharedInstance();
        loginViewController.showNavbar = true
        loginViewController.showSettingsIcon = false
        loginViewController.navBarColor = UIColor.white
//        loginViewController.navBarFont = UIFont (name: "HelveticaNeue-Medium", size: 19);
        loginViewController.navBarTextColor = UIColor.darkGray
        
        SalesforceSDKManager.shared().launch()

        
        return true
    }

    func stylize() {
        
        UIApplication.shared.statusBarStyle = .default
        
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName : UIColor.imaGreyishBrown, NSFontAttributeName: UIFont(name:"GTWalsheim", size:18)!]
        
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .any, barMetrics: .default)
        UINavigationBar.appearance().shadowImage = UIImage()
        
        let customFont = UIFont(name: "GTWalsheim-Light", size: 14.0)!
        UIBarButtonItem.appearance().setTitleTextAttributes([NSFontAttributeName: customFont], for: .normal)
        
        
        let titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white, NSFontAttributeName: UIFont(name: "GTWalsheim", size: 16)!]
        UISegmentedControl.appearance().setTitleTextAttributes(titleTextAttributes, for: .selected)
        UISegmentedControl.appearance().setTitleTextAttributes(titleTextAttributes, for: .normal)
        UISegmentedControl.appearance().setTitleTextAttributes(titleTextAttributes, for: .highlighted)
        
        
    }

    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    
    
    func handleSdkManagerLogout() {
        self.log(.debug, msg: "SFAuthenticationManager logged out.  Resetting app.")
        SalesforceSDKManager.shared().launch()
        _ = self.window?.rootViewController?.navigationController?.popToRootViewController(animated: false)
        
        //        exit(0)
        //        self.resetViewState { () -> () in
        //            self.initializeAppViewState()
        //
        //            // Multi-user pattern:
        //            // - If there are two or more existing accounts after logout, let the user choose the account
        //            //   to switch to.
        //            // - If there is one existing account, automatically switch to that account.
        //            // - If there are no further authenticated accounts, present the login screen.
        //            //
        //            // Alternatively, you could just go straight to re-initializing your app state, if you know
        //            // your app does not support multiple accounts.  The logic below will work either way.
        //
        //            var numberOfAccounts : Int;
        //            let allAccounts = SFUserAccountManager.sharedInstance().allUserAccounts as [SFUserAccount]?
        //            if allAccounts != nil {
        //                numberOfAccounts = allAccounts!.count;
        //            } else {
        //                numberOfAccounts = 0;
        //            }
        //
        //            if numberOfAccounts > 1 {
        //                let userSwitchVc = SFDefaultUserManagementViewController(completionBlock: {
        //                    action in
        //                    self.window!.rootViewController!.dismissViewControllerAnimated(true, completion: nil)
        //                })
        //                self.window!.rootViewController!.presentViewController(userSwitchVc, animated: true, completion: nil)
        //            } else {
        //                if (numberOfAccounts == 1) {
        //                    SFUserAccountManager.sharedInstance().currentUser = allAccounts![0]
        //                }
        //                SalesforceSDKManager.sharedManager().launch()
        //            }
        //        }
    }


}

