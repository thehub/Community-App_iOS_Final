//
//  MemberViewController.swift
//  ImpactHub
//
//  Created by Niklas on 18/05/2017.
//  Copyright © 2017 Lightful Ltd. All rights reserved.
//

import UIKit

class JobViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UIGestureRecognizerDelegate {

    var job: Job!
    
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
    }
    
    
    
    let gradientLayer: CAGradientLayer = CAGradientLayer()
    

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        

        self.title = job.name
        
        self.companyPhotoImageView.image = UIImage(named: job.company.photo)
        
        
        
        collectionView.register(UINib.init(nibName: TitleViewModel.cellIdentifier, bundle: nil), forCellWithReuseIdentifier: TitleViewModel.cellIdentifier)
        collectionView.register(UINib.init(nibName: JobDetailViewModel.cellIdentifier, bundle: nil), forCellWithReuseIdentifier: JobDetailViewModel.cellIdentifier)
        collectionView.register(UINib.init(nibName: JobViewModel.cellIdentifier, bundle: nil), forCellWithReuseIdentifier: JobViewModel.cellIdentifier)
        collectionView.register(UINib.init(nibName: ProjectViewModel.cellIdentifier, bundle: nil), forCellWithReuseIdentifier: ProjectViewModel.cellIdentifier)

        
        
        
        // Title
        data.append(TitleViewModel(title: "JOBS DESCRIPTION", cellSize: CGSize(width: view.frame.width, height: 50)))
        
        
        // Job Detail
        data.append(JobDetailViewModel(job: job, cellSize: CGSize(width: view.frame.width, height: 0)))
        
        // Title
        data.append(TitleViewModel(title: "RELATED JOBS", cellSize: CGSize(width: view.frame.width, height: 50)))
        
        let company = Company(id: "dsfsd", name: "Aspite", type: "dsfsdfs", photo: "companyImage", logo:"companyLogo", blurb: "Lorem ipsum", locationName: "London, UK", website: "www.bbc.co.uk", size: "10 - 50")
        
        let item1 = Job(id: "zxddz", name: "Marketing Strategist", company: company, description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.", locationName: "London, UK", type: "Fulltime", salary: "€ 30.000 / 40.000 p/a", companyName: "Aspire", companyId: "dsfsdfsdfs")
        
        
        let cellWidth: CGFloat = self.view.frame.width
        let viewModel1 = JobViewModel(job: item1, cellSize: CGSize(width: cellWidth, height: 145))
        let viewModel2 = JobViewModel(job: item1, cellSize: CGSize(width: cellWidth, height: 145))
        let viewModel3 = JobViewModel(job: item1, cellSize: CGSize(width: cellWidth, height: 145))
        let viewModel4 = JobViewModel(job: item1, cellSize: CGSize(width: cellWidth, height: 145))
        
        data.append(viewModel1)
        data.append(viewModel2)
        data.append(viewModel3)
        data.append(viewModel4)

        // Title
        data.append(TitleViewModel(title: "RELATED PROJECTS", cellSize: CGSize(width: view.frame.width, height: 50)))

        
        data.append(ProjectViewModel(project: Project(name: "Zero to one: new startups and Innovative Ideas"), cellSize: CGSize(width: view.frame.width, height: 370)))
        
        data.append(ProjectViewModel(project: Project(name: "Zero to one: new startups and Innovative Ideas"), cellSize: CGSize(width: view.frame.width, height: 370)))
        
        data.append(ProjectViewModel(project: Project(name: "Zero to one: new startups and Innovative Ideas"), cellSize: CGSize(width: view.frame.width, height: 370)))
        
        data.append(ProjectViewModel(project: Project(name: "Zero to one: new startups and Innovative Ideas"), cellSize: CGSize(width: view.frame.width, height: 370)))
        
        data.append(ProjectViewModel(project: Project(name: "Zero to one: new startups and Innovative Ideas"), cellSize: CGSize(width: view.frame.width, height: 370)))


        
        
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
        gradientLayer.frame = self.fadeView.layer.bounds
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
        
        
        if let vm = data[indexPath.item] as? JobDetailViewModel {
            let cellWidth: CGFloat = self.collectionView.frame.width
            let height = vm.job.description.height(withConstrainedWidth: cellWidth, font:UIFont(name: "GTWalsheim-Light", size: 15)!) + 100 // add extra height for the standard elements, titles, lines, sapcing etc.
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
        if offset < 350 && offset > 0 {
            compnayPhotoTopConstraint.constant = -(offset * 0.5)
        }

        if scrollView.contentOffset.y > 200 {
            self.tabBarController?.tabBar.isHidden = false
            connectButtonBottomConsatraint?.constant = connectButtonBottomConsatraintDefault + self.navigationController!.navigationBar.frame.height
            UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseInOut, animations: {                self.setNeedsStatusBarAppearanceUpdate()
                self.view.layoutIfNeeded()
            }) { (_) in
                
            }
            
        }
        else if scrollView.contentOffset.y < 200 {
            self.tabBarController?.tabBar.isHidden = true
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

extension JobViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = data[indexPath.item].cellInstance(collectionView, indexPath: indexPath)
        return cell
    }
}

