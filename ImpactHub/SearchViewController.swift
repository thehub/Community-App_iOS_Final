//
//  SearchViewController.swift
//  ImpactHub
//
//  Created by Niklas Alvaeus on 19/05/2017.
//  Copyright © 2017 Lightful Ltd. All rights reserved.
//

import UIKit
import PromiseKit
import SalesforceSDKCore


class SearchViewController: ListWithSearchViewController, CreatePostViewControllerDelegate {

    @IBOutlet weak var noresultsView: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        collectionView.register(UINib.init(nibName: GroupViewModel.cellIdentifier, bundle: nil), forCellWithReuseIdentifier: GroupViewModel.cellIdentifier)
        
        collectionView.register(UINib.init(nibName: MemberViewModel.cellIdentifier, bundle: nil), forCellWithReuseIdentifier: MemberViewModel.cellIdentifier)

        collectionView.register(UINib.init(nibName: ProjectViewModel.cellIdentifier, bundle: nil), forCellWithReuseIdentifier: ProjectViewModel.cellIdentifier)
        
        collectionView.register(UINib.init(nibName: "CompanyCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CompanyCell")

        collectionView.register(UINib.init(nibName: EventViewModel.cellIdentifier, bundle: nil), forCellWithReuseIdentifier: EventViewModel.cellIdentifier)


    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(color: UIColor.white), for: .default)
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.imaGreyishBrown, NSFontAttributeName: UIFont(name:"GTWalsheim", size:18)!]
        self.navigationController?.navigationBar.barStyle = .default
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // If coming from home short cut
        if showSerachOnOpen {
            showSearch()
            showSerachOnOpen = false
        }
    }
    
    var showSerachOnOpen = false
    
    func showSearch() {
        showSerachOnOpen = false
        self.searchBar?.becomeFirstResponder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.cancelSearching()
    }
    
    var selectedMemberVM: MemberViewModel?
    var selectedGroupVM: GroupViewModel?
    var selectedProjectVM: ProjectViewModel?
    var selectedEventVM: EventViewModel?
    var selectedCompanyVM: CompanyViewModel?
    var memberToSendMessage: Member?

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: self)
        if segue.identifier == "ShowMember" {
            if let vc = segue.destination as? MemberViewController, let selectedItem = selectedMemberVM {
                vc.member = selectedItem.member
            }
        }
        else if segue.identifier == "ShowGroup" {
            if let vc = segue.destination as? GroupViewController, let selectedItem = selectedGroupVM {
                vc.group = selectedItem.group
            }
        }
        else if segue.identifier == "ShowProject" {
            if let vc = segue.destination as? ProjectViewController, let selectedItem = selectedProjectVM {
                vc.project = selectedItem.project
            }
        }
        else if segue.identifier == "ShowEvent" {
            if let vc = segue.destination as? EventViewController, let selectedItem = selectedEventVM {
                vc.event = selectedItem.event
            }
        }
        else if segue.identifier == "ShowCompany" {
            if let vc = segue.destination as? CompanyViewController, let selectedItem = selectedCompanyVM {
                vc.company = selectedItem.company
            }
        }
        else if segue.identifier == "ShowCreatePost" {
            if let navVC = segue.destination as? UINavigationController {
                if let vc = navVC.viewControllers.first as? CreatePostViewController, let contactId = cellWantsToSendContactRequest?.vm?.member.contactId {
                    vc.delegate = self
                    vc.createType = .contactRequest(contactId: contactId)
                }
            }
        }
        else if segue.identifier == "ShowMessageThread" {
            if let vc = segue.destination as? MessagesThreadViewController, let member = self.memberToSendMessage {
                vc.member = member
            }
        }
    }
    
    func didCreatePost(post: Post) {
        
    }
    
    func didCreateComment(comment: Comment) {
        
    }
    
    func didSendContactRequest() {
        self.cellWantsToSendContactRequest?.connectRequestStatus = .outstanding
    }
    
    var cellWantsToSendContactRequest: MemberCollectionViewCell?
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    
    
    
    // MARK: Search
    
    override func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // user did type something, check our datasource for text that looks the same
        applySearchAndFilter(searchText: searchText)
    }
    
    override func applySearchAndFilter(searchText: String) {
        
    }
    
    
    override func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.cancelSearching()
        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseOut, animations: {
            self.noresultsView.alpha = 0
        }) { (_) in
        }
        self.collectionView?.reloadData()
    }
    
    override func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.view.endEditing(true)
    }
    
    override func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        //        self.searchBar!.setShowsCancelButton(true, animated: true)
        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseOut, animations: {
            self.noresultsView.alpha = 0
        }) { (_) in
        }
    }
    
    override func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        // this method is being called when search btn in the keyboard tapped
        // we set searchBarActive = NO
        // but no need to reloadCollectionView
        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseOut, animations: {
            self.noresultsView.alpha = 0
        }) { (_) in
        }

        
        if let searchText = self.searchBar?.text {
            if searchText.characters.count == 0 {
                self.dataAll.removeAll()
                self.data.removeAll()
                self.collectionView.reloadData()
                UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseOut, animations: {
                    self.noresultsView.alpha = 1
                }) { (_) in
                }
                return
            }
            
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
            self.collectionView?.alpha = 0
            firstly {
                ContactRequestManager.shared.refresh()
                }.then { contactRequests -> Void in
                    print("refreshed")
                }.then {
                    APIClient.shared.globalSearch(searchTerm: searchText)
                }.then { results -> Void in
                                    self.dataAll.removeAll()
                                    self.data.removeAll()
                                    self.collectionView.reloadData()
                                    let cellWidth: CGFloat = self.view.frame.width
                    
                                    results.members.forEach({ (member) in
                                        // Remove our selves
                                        if member.contactId != SessionManager.shared.me?.member.contactId ?? "" {
                                            member.contactRequest = ContactRequestManager.shared.getRelevantContactRequestFor(member: member)
                                            self.dataAll.append(MemberViewModel(member: member, delegate: self, cellSize: CGSize(width: cellWidth, height: 105)))
                                        }
                                    })
                    
                                    results.groups.forEach({ (group) in
                                        let viewModel = GroupViewModel(group: group, cellSize: CGSize(width: cellWidth, height: 170))
                                        self.dataAll.append(viewModel)
                                    })
                    
                                    results.projects.forEach({ (project) in
                                        let viewModel = ProjectViewModel(project: project, cellSize: CGSize(width: cellWidth, height: 370))
                                        self.dataAll.append(viewModel)
                                    })
                    
                                    results.companies.forEach({ (company) in
                                        let viewModel1 = CompanyViewModel(company: company, cellSize: CGSize(width: cellWidth, height: 200))
                                        self.dataAll.append(viewModel1)
                                    })
                    
                                    results.events.forEach({ (event) in
                                        self.dataAll.append(EventViewModel(event: event, cellSize: CGSize(width: self.view.frame.width, height: 370)))
                                    })

                }.always {
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                    self.data = self.filterContentForSearchText(dataToFilter: self.dataAll, searchText: searchText)
                    
                    if self.data.count == 0 {
                        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseOut, animations: {
                            self.noresultsView.alpha = 1
                        }) { (_) in
                        }
                    }
                    else {
                        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseOut, animations: {
                            self.noresultsView.alpha = 0
                        }) { (_) in
                        }
                    }
                    
                    self.collectionView?.alpha = 0
                    self.collectionView?.reloadData()
                    self.collectionView?.setContentOffset(CGPoint.init(x: 0, y: -20), animated: false)
                    UIView.animate(withDuration: 0.3, delay: 0.1, options: .curveEaseInOut, animations: {
                        self.collectionView?.setContentOffset(CGPoint.init(x: 0, y: 0), animated: false)
                        self.collectionView?.alpha = 1
                    }, completion: { (_) in
                        
                    })
                }.catch { error in
                    debugPrint(error.localizedDescription)
            }
            
        }
        

        self.searchBar!.setShowsCancelButton(false, animated: false)
    }

    
    
    override func filterContentForSearchText(dataToFilter: [CellRepresentable], searchText:String) -> [CellRepresentable] {
        print(searchText)
        return dataToFilter
    }
}


extension SearchViewController: MemberCollectionViewCellDelegate {
    
    func wantsToCreateNewMessage(member: Member) {
        self.memberToSendMessage = member
        self.performSegue(withIdentifier: "ShowMessageThread", sender: self)
    }
    
    
    func wantsToSendContactRequest(member: Member, cell: MemberCollectionViewCell) {
        self.cellWantsToSendContactRequest = cell
        self.performSegue(withIdentifier: "ShowCreatePost", sender: self)
    }
    
}


extension SearchViewController {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let vm = data[indexPath.item] as? MemberViewModel {
            selectedMemberVM = vm
            performSegue(withIdentifier: "ShowMember", sender: self)
        }
        else if let vm = data[indexPath.item] as? GroupViewModel {
            selectedGroupVM = vm
            performSegue(withIdentifier: "ShowGroup", sender: self)
        }
        else if let vm = data[indexPath.item] as? ProjectViewModel {
            selectedProjectVM = vm
            performSegue(withIdentifier: "ShowProject", sender: self)
        }
        else if let vm = data[indexPath.item] as? EventViewModel {
            selectedEventVM = vm
            performSegue(withIdentifier: "ShowEvent", sender: self)
        }
        else if let vm = data[indexPath.item] as? CompanyViewModel {
            selectedCompanyVM = vm
            performSegue(withIdentifier: "ShowCompany", sender: self)
        }

    }
}



extension SearchViewController {
    
    override func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        
        guard let indexPath = collectionView.indexPathForItem(at: location) else { return nil }
        guard let cell = collectionView.cellForItem(at: indexPath) else { return nil }
        
        var detailVC: UIViewController!
        
        if let vm = data[indexPath.item] as? MemberViewModel {
            selectedMemberVM = vm
            detailVC = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "MemberViewController")
            (detailVC as! MemberViewController).member = selectedMemberVM?.member
            previewingContext.sourceRect = cell.frame
            return detailVC
        }
        else if let vm = data[indexPath.item] as? GroupViewModel {
            selectedGroupVM = vm
            detailVC = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "GroupViewController")
            (detailVC as! GroupViewController).group = selectedGroupVM?.group
            previewingContext.sourceRect = cell.frame
            return detailVC
        }
        else if let vm = data[indexPath.item] as? ProjectViewModel {
            selectedProjectVM = vm
            detailVC = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "ProjectViewController")
            (detailVC as! ProjectViewController).project = selectedProjectVM?.project
            previewingContext.sourceRect = cell.frame
            return detailVC
        }
        else if let vm = data[indexPath.item] as? EventViewModel {
            selectedEventVM = vm
            detailVC = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "EventViewController")
            (detailVC as! EventViewController).event = selectedEventVM?.event
            previewingContext.sourceRect = cell.frame
            return detailVC
        }
        else if let vm = data[indexPath.item] as? CompanyViewModel {
            selectedCompanyVM = vm
            detailVC = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "CompanyViewController")
            (detailVC as! CompanyViewController).company = selectedCompanyVM?.company
            previewingContext.sourceRect = cell.frame
            return detailVC
        }

        return nil
        
    }
}
