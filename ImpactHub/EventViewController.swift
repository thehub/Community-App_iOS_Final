//
//  MemberViewController.swift
//  ImpactHub
//
//  Created by Niklas on 18/05/2017.
//  Copyright © 2017 Lightful Ltd. All rights reserved.
//

import UIKit

class EventViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UIGestureRecognizerDelegate {

    var event: Event!
    
    @IBOutlet weak var companyPhotoImageView: UIImageView!
    @IBOutlet weak var fadeView: UIView!
    @IBOutlet weak var compnayPhotoTopConstraint: NSLayoutConstraint!

    @IBOutlet weak var titleLabelContainerView: UIView!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var data = [CellRepresentable]()
    
    @IBOutlet weak var connectButtonBottomConsatraint: NSLayoutConstraint?
    var connectButtonBottomConsatraintDefault: CGFloat = 0
    @IBOutlet weak var connectButton: UIButton?



    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.tabBarController?.tabBar.isHidden = true
        
        
        UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseInOut, animations: {
            self.setNeedsStatusBarAppearanceUpdate()
        }) { (_) in
            
        }

    }
    
    
    
    let gradientLayer: CAGradientLayer = CAGradientLayer()
    

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        

        self.title = event.name
        
        self.companyPhotoImageView.image = UIImage(named: event.photo)
        
        
        
        collectionView.register(UINib.init(nibName: TitleViewModel.cellIdentifier, bundle: nil), forCellWithReuseIdentifier: TitleViewModel.cellIdentifier)
        collectionView.register(UINib.init(nibName: EventDetailViewModel.cellIdentifier, bundle: nil), forCellWithReuseIdentifier: EventDetailViewModel.cellIdentifier)
        collectionView.register(UINib.init(nibName: JobViewModel.cellIdentifier, bundle: nil), forCellWithReuseIdentifier: JobViewModel.cellIdentifier)
        collectionView.register(UINib.init(nibName: ProjectViewModel.cellIdentifier, bundle: nil), forCellWithReuseIdentifier: ProjectViewModel.cellIdentifier)
        collectionView.register(UINib.init(nibName: MemberFeedItemViewModel.cellIdentifier, bundle: nil), forCellWithReuseIdentifier: MemberFeedItemViewModel.cellIdentifier)
        
        
        // Title
        data.append(TitleViewModel(title: "DESCRIPTION", cellSize: CGSize(width: view.frame.width, height: 50)))
        
        
        // Event Detail
        data.append(EventDetailViewModel(event: event, cellSize: CGSize(width: view.frame.width, height: 0)))
        
        // Title
        data.append(TitleViewModel(title: "DISCUSSION", cellSize: CGSize(width: view.frame.width, height: 50)))

        var member = Member.init(name: "Test", job: "Test", photo: "photo", blurb: "test", aboutMe: "test", locationName: "London")

        data.append(MemberFeedItemViewModel(member: member, cellSize: CGSize(width: view.frame.width, height: 150)))
        data.append(MemberFeedItemViewModel(member: member, cellSize: CGSize(width: view.frame.width, height: 150)))
        data.append(MemberFeedItemViewModel(member: member, cellSize: CGSize(width: view.frame.width, height: 150)))
        data.append(MemberFeedItemViewModel(member: member, cellSize: CGSize(width: view.frame.width, height: 150)))


        
        
    }
    

    var shouldHideStatusBar = true
    
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
        
        let startingColorOfGradient = UIColor(hexString: "252424").withAlphaComponent(0.0).cgColor
        let midColor = UIColor(hexString: "181818").withAlphaComponent(0.66).cgColor
        let endingColorOFGradient = UIColor(hexString: "252424").withAlphaComponent(1.0).cgColor
        gradientLayer.frame = self.fadeView.layer.bounds
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y:1.0)
        gradientLayer.locations = [NSNumber.init(value: 0.0), NSNumber.init(value: 0.8), NSNumber.init(value: 1.0)]
        gradientLayer.colors = [startingColorOfGradient, midColor, endingColorOFGradient]
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
        
        
        if let vm = data[indexPath.item] as? EventDetailViewModel {
            let cellWidth: CGFloat = self.collectionView.frame.width
            let height = vm.event.description.height(withConstrainedWidth: cellWidth, font:UIFont(name: "GTWalsheim-Light", size: 12.5)!) + 280 // add extra height for the standard elements, titles, lines, sapcing etc.
            return CGSize(width: view.frame.width, height: height)
        }
        
        if let vm = data[indexPath.item] as? ProjectViewModel {
            let cellWidth: CGFloat = self.collectionView.frame.width
            let width = ((cellWidth - 40) / 1.6)
            let heightToUse = width + 155
            return CGSize(width: view.frame.width, height: heightToUse)
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
        if let vm = data[indexPath.item] as? JobViewModel {
            self.selectJob = vm.job
            
            let vc = storyboard?.instantiateViewController(withIdentifier: "JobViewController") as! JobViewController
            vc.job = self.selectJob
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else if let vm = data[indexPath.item] as? ProjectViewModel {
            self.selectProject = vm.project
            self.performSegue(withIdentifier: "ShowProject", sender: self)
        }

    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowProject" {
            if let vc = segue.destination as? ProjectViewController, let selectProject = selectProject {
                vc.project = selectProject
            }
        }
    }
    

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let offset = scrollView.contentOffset.y
        if offset < 450 && offset > -100 {
            compnayPhotoTopConstraint.constant = -(offset * 1.0)
            self.view.layoutIfNeeded()
        }

        if scrollView.contentOffset.y > 200 {
            self.tabBarController?.tabBar.isHidden = false
            self.shouldHideStatusBar = false
            self.navigationController?.setNavigationBarHidden(false, animated: true)

            let navBarHeight = self.navigationController?.navigationBar.frame.height ?? 0.0
            connectButtonBottomConsatraint?.constant = connectButtonBottomConsatraintDefault + navBarHeight
            UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseInOut, animations: {
                self.setNeedsStatusBarAppearanceUpdate()
                self.view.layoutIfNeeded()
            }) { (_) in
                
            }
            
        }
        else if scrollView.contentOffset.y < 200 {
            self.tabBarController?.tabBar.isHidden = true
            self.shouldHideStatusBar = true
            self.navigationController?.setNavigationBarHidden(true, animated: true)

            connectButtonBottomConsatraint?.constant = connectButtonBottomConsatraintDefault
            UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseInOut, animations: {
                self.setNeedsStatusBarAppearanceUpdate()
                self.view.layoutIfNeeded()
            }) { (_) in
                
            }
        }
        
    }
    
    
    
    

    
    
    
    
    
    
    @IBAction func applyTap(_ sender: Any) {
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension EventViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = data[indexPath.item].cellInstance(collectionView, indexPath: indexPath)
        return cell
    }
}

