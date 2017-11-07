//
//  HomeViewController.swift
//  ImpactHub
//
//  Created by Niklas on 17/05/2017.
//  Copyright © 2017 Lightful Ltd. All rights reserved.
//

import UIKit
import SalesforceSDKCore
import UserNotifications


class HomeViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!

    @IBOutlet weak var homeNavBar: UINavigationBar!
    var data = [CellRepresentable]()

    enum Section {
        case members
        case companies
        case groups
        case goals
        case jobs
        case events
        case projects
        
        var title: String {
            switch self {
            case .members:
                return "Members"
            case .companies:
                return "Companies"
            case .groups:
                return "Groups"
            case .goals:
                return "Impact Goals"
            case .jobs:
                return "Jobs"
            case .events:
                return "Events"
            case .projects:
                return "Projects"
            }
        }
        
        var icon: UIImage {
            switch self {
            case .members:
                return UIImage(named:"membersHomeIcon")!
            case .companies:
                return UIImage(named:"companiesHomeIcon")!
            case .groups:
                return UIImage(named:"groupsHomeIcon")!
            case .goals:
                return UIImage(named:"goalsHomeIcon")!
            case .jobs:
                return UIImage(named:"jobsHomeIcon")!
            case .events:
                return UIImage(named:"eventsHomeIcon")!
            case .projects:
                return UIImage(named:"projectsHomeIcon")!
            }
        }
        
        var segue: String {
            switch self {
            case .members:
                return "ShowMembers"
            case .companies:
                return "ShowCompanies"
            case .groups:
                return "ShowGroups"
            case .goals:
                return "ShowGoals"
            case .jobs:
                return "ShowJobs"
            case .events:
                return "ShowEvents"
            case .projects:
                return "ShowProjects"
            }
        }
        
        var identifier: String {
            switch self {
            case .members:
                return "MembersViewController"
            case .companies:
                return "CompaniesViewController"
            case .groups:
                return "GroupsViewController"
            case .goals:
                return "GoalsViewController"
            case .jobs:
                return "JobsViewController"
            case .events:
                return "EventsViewController"
            case .projects:
                return "ProjectsViewController"
            }
        }
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.register(UINib.init(nibName: HomeCellViewModel.cellIdentifier, bundle: nil), forCellWithReuseIdentifier: HomeCellViewModel.cellIdentifier)

        if(traitCollection.forceTouchCapability == .available){
            registerForPreviewing(with: self, sourceView: self.collectionView)
        }

        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            // Do any additional setup after loading the view.
            if #available(iOS 10.0, *) {
                UNUserNotificationCenter.current().delegate = UIApplication.shared.delegate as? UNUserNotificationCenterDelegate
                UNUserNotificationCenter.current().requestAuthorization(options: [.badge, .sound, .alert], completionHandler: {(granted, error) in
                    if (granted) {
                        DispatchQueue.main.async {
                            UIApplication.shared.registerForRemoteNotifications()
                        }
                    }
                    else {
                        //Do stuff if unsuccessful...
                    }
                })
            } else {
                let types:UIUserNotificationType = ([.alert, .sound, .badge])
                let settings:UIUserNotificationSettings = UIUserNotificationSettings(types: types, categories: nil)
                UIApplication.shared.registerUserNotificationSettings(settings)
                UIApplication.shared.registerForRemoteNotifications()
            }
            SFPushNotificationManager.sharedInstance().registerForRemoteNotifications()
        }

        let cellWidth: CGFloat = self.view.frame.width
        self.data.append(HomeCellViewModel(section: HomeViewController.Section.members, cellSize: CGSize(width: cellWidth, height: 70)))
        self.data.append(HomeCellViewModel(section: HomeViewController.Section.companies, cellSize: CGSize(width: cellWidth, height: 70)))
        self.data.append(HomeCellViewModel(section: HomeViewController.Section.goals, cellSize: CGSize(width: cellWidth, height: 70)))
        self.data.append(HomeCellViewModel(section: HomeViewController.Section.jobs, cellSize: CGSize(width: cellWidth, height: 70)))
        self.data.append(HomeCellViewModel(section: HomeViewController.Section.projects, cellSize: CGSize(width: cellWidth, height: 70)))
        self.data.append(HomeCellViewModel(section: HomeViewController.Section.groups, cellSize: CGSize(width: cellWidth, height: 70)))
        self.data.append(HomeCellViewModel(section: HomeViewController.Section.events, cellSize: CGSize(width: cellWidth, height: 70)))

        self.navigationController?.navigationBar.barStyle = .black
        homeNavBar.barStyle = .black
        
        homeNavBar.setBackgroundImage(UIImage(color: UIColor.imaGrapefruit), for: .default)
        homeNavBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white, NSFontAttributeName: UIFont(name:"GTWalsheim", size:18)!]
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.tabBarController?.tabBar.isHidden = false

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.navigationBar.barStyle = .black
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(color: UIColor.white), for: .default)
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.imaGreyishBrown, NSFontAttributeName: UIFont(name:"GTWalsheim", size:18)!]
        self.navigationController?.navigationBar.barStyle = .default
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
}


extension HomeViewController {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let vm = data[indexPath.item] as? HomeCellViewModel {
            performSegue(withIdentifier: vm.section.segue, sender: self)
        }
    }
}


extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return data[indexPath.item].cellInstance(collectionView, indexPath: indexPath)
    }
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return data[indexPath.item].cellSize
        
    }
}

extension HomeViewController: UIViewControllerPreviewingDelegate {
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        
        guard let indexPath = collectionView.indexPathForItem(at: location) else { return nil }
        guard let cell = collectionView.cellForItem(at: indexPath) else { return nil }
        
        var detailVC: UIViewController!
        if let vm = data[indexPath.item] as? HomeCellViewModel {
            detailVC = storyboard?.instantiateViewController(withIdentifier: vm.section.identifier)
            //        detailVC.preferredContentSize = CGSize(width: 0.0, height: 300)
            previewingContext.sourceRect = cell.frame
            return detailVC
        }
        
        return nil
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        show(viewControllerToCommit, sender: self)
    }
}

