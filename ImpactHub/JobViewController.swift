//
//  MemberViewController.swift
//  ImpactHub
//
//  Created by Niklas on 18/05/2017.
//  Copyright © 2017 Lightful Ltd. All rights reserved.
//

import UIKit
import Kingfisher
import PromiseKit
import SafariServices


class JobViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UIGestureRecognizerDelegate, UIViewControllerPreviewingDelegate {

    var job: Job!
    
    @IBOutlet weak var companyPhotoImageView: UIImageView!
    @IBOutlet weak var fadeView: UIView!
    @IBOutlet weak var compnayPhotoTopConstraint: NSLayoutConstraint!

    @IBOutlet weak var titleLabelContainerView: UIView!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var data = [CellRepresentable]()
    
    @IBOutlet weak var connectButtonBottomConsatraint: NSLayoutConstraint?
    var connectButtonBottomConsatraintDefault: CGFloat = 20
    @IBOutlet weak var connectButton: UIButton?



    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if(traitCollection.forceTouchCapability == .available){
            registerForPreviewing(with: self, sourceView: self.collectionView)
        }

        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
        
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    
    
    let gradientLayer: CAGradientLayer = CAGradientLayer()
    
    deinit {
        print("\(#file, #function)")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        

        self.title = job.name
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.tabBarController?.tabBar.isHidden = false

        if let photoUrl = job.photoUrl {
            self.companyPhotoImageView.kf.setImage(with: photoUrl, options: [.transition(.fade(0.2))])
        }
        
        collectionView.register(UINib.init(nibName: TitleViewModel.cellIdentifier, bundle: nil), forCellWithReuseIdentifier: TitleViewModel.cellIdentifier)
        collectionView.register(UINib.init(nibName: JobDetailViewModel.cellIdentifier, bundle: nil), forCellWithReuseIdentifier: JobDetailViewModel.cellIdentifier)
        collectionView.register(UINib.init(nibName: JobViewModel.cellIdentifier, bundle: nil), forCellWithReuseIdentifier: JobViewModel.cellIdentifier)
        collectionView.register(UINib.init(nibName: ProjectViewModel.cellIdentifier, bundle: nil), forCellWithReuseIdentifier: ProjectViewModel.cellIdentifier)
        collectionView.register(UINib.init(nibName: RelatedViewModel.cellIdentifier, bundle: nil), forCellWithReuseIdentifier: RelatedViewModel.cellIdentifier)

        self.data.removeAll()
        collectionView.reloadData()

        
        let cellWidth: CGFloat = self.view.frame.width
        
        // Title
        data.append(TitleViewModel(title: "JOBS DESCRIPTION", cellSize: CGSize(width:cellWidth, height: 50)))
        
        
        // Job Detail
        data.append(JobDetailViewModel(job: job, cellSize: CGSize(width: cellWidth, height: 0)))
        
        // Title
//        data.append(TitleViewModel(title: "RELATED JOBS", cellSize: CGSize(width: view.frame.width, height: 50)))
//        let viewModel1 = RelatedViewModel(job: job1, cellSize: CGSize(width: cellWidth, height: 140))
//        data.append(viewModel1)

        // Related Projects
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        firstly {
            APIClient.shared.getProject(jobId: job.id)
            }.then { projects -> Void in
//                var indexPaths = [IndexPath]()
//                var startAtIndexItem = self.data.count - 1
                if projects.count > 0 {
                    // Title
                    self.data.append(TitleViewModel(title: "RELATED PROJECTS", cellSize: CGSize(width: cellWidth, height: 50)))
//                    indexPaths.append(IndexPath(item: startAtIndexItem, section: 0))
//                    startAtIndexItem += 1
                    projects.forEach({ (project) in
                        self.data.append(RelatedViewModel(project: project, cellSize: CGSize(width: cellWidth, height: 140)))
//                        indexPaths.append(IndexPath(item: startAtIndexItem, section: 0))
//                        startAtIndexItem += 1
                    })
//                    self.collectionView.insertItems(at: indexPaths)
                }
            }.always {
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                self.collectionView.reloadData()
            }.catch { error in
                debugPrint(error.localizedDescription)
        }
        
    }
    

    var shouldHideStatusBar = false
    
    override var prefersStatusBarHidden: Bool {
        return shouldHideStatusBar
    }
    
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return .slide
    }
    
    var didLayout = false

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        gradientLayer.removeFromSuperlayer()
        let startingColorOfGradient = UIColor.init(white: 1.0, alpha: 0.0).cgColor
        let endingColorOFGradient = UIColor.init(white: 1.0, alpha: 1.0).cgColor
        gradientLayer.frame = fadeView.layer.bounds
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y:0.8)
        gradientLayer.colors = [startingColorOfGradient , endingColorOFGradient]
        fadeView.layer.insertSublayer(gradientLayer, at: 0)

        if !didLayout {
            didLayout = true
            connectButtonBottomConsatraintDefault = connectButtonBottomConsatraint?.constant ?? 0
        }

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
//        self.navigationController?.navigationBar.shadowImage = nil

    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
//        if let vm = data[indexPath.item] as? MemberFeedItemViewModel {
//            let cellWidth: CGFloat = self.collectionView.frame.width
//            let height = vm.post.text.height(withConstrainedWidth: cellWidth - (62 + 8), font:UIFont(name: "GTWalsheim-Light", size: 14)!) + 135 // add extra height for the standard elements, titles, lines, sapcing etc.
//            return CGSize(width: view.frame.width, height: height)
//        }
        
        if let vm = data[indexPath.item] as? JobDetailViewModel {
            let cellWidth: CGFloat = self.collectionView.frame.width
            let height = vm.job.description.height(withConstrainedWidth: cellWidth, font:UIFont(name: "GTWalsheim-Light", size: 15)!) + 100 // add extra height for the standard elements, titles, lines, sapcing etc.
            return CGSize(width: view.frame.width, height: height)
        }
        
        var cellSize = data[indexPath.item].cellSize
        if cellSize == .zero {
            let cellHeight = self.view.frame.height
            cellSize = CGSize(width: view.frame.width, height: cellHeight)
        }
        return cellSize
        
    }
    
    var selectJob: Job?
    var selectProject: Project?

    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let vm = data[indexPath.item] as? RelatedViewModel {
            if let project = vm.project {
                self.selectProject = project
                self.performSegue(withIdentifier: "ShowProject", sender: self)
            }
            else if let job = vm.job {
                self.selectJob = job
                let vc = storyboard?.instantiateViewController(withIdentifier: "JobViewController") as! JobViewController
                vc.job = self.selectJob
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }

    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if segue.identifier == "ShowProject" {
            if let vc = segue.destination as? ProjectViewController, let selectProject = selectProject {
                vc.project = selectProject
            }
        }

    }
    

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let offset = scrollView.contentOffset.y
        if offset < 350 && offset > 0 {
            compnayPhotoTopConstraint.constant = -(offset * 0.5)
            self.view.layoutIfNeeded()
        }
    }

    @IBAction func applyTap(_ sender: Any) {
        guard let website = job?.applicationURL else { return }
        
        if let url = URL(string: website) {
            let svc = SFSafariViewController(url: url)
            self.present(svc, animated: true, completion: nil)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension JobViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = data[indexPath.item].cellInstance(collectionView, indexPath: indexPath)
        return cell
    }
}

extension JobViewController: CreatePostViewControllerDelegate {
    func didSendContactRequest() {
    }

    func didCreatePost(post: Post) {
    }
    
    func didCreateComment(comment: Comment) {
    }
}

extension JobViewController {
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        
        guard let indexPath = collectionView.indexPathForItem(at: location) else { return nil }
        guard let cell = collectionView.cellForItem(at: indexPath) else { return nil }
        
        var detailVC: UIViewController!
        
        if let vm = data[indexPath.item] as? RelatedViewModel {
            
            if let project = vm.project {
                detailVC = storyboard?.instantiateViewController(withIdentifier: "ProjectViewController")
                (detailVC as! ProjectViewController).project = project
            }
            else if let job = vm.job {
                detailVC = storyboard?.instantiateViewController(withIdentifier: "JobViewController")
                (detailVC as! JobViewController).job = job
            }
            
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

extension JobViewController: CellBackDelegate {
    func goBack() {
        self.navigationController?.popViewController(animated: true)
    }
}


