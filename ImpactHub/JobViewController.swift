//
//  JobViewController.swift
//  ImpactHub
//
//  Created by Niklas Alvaeus on 19/05/2017.
//  Copyright © 2017 Lightful Ltd. All rights reserved.
//

import UIKit

class JobViewController: UIViewController {

    var job: Job!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var companyButton: UIButton!
    @IBOutlet weak var locationNameLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var salaryLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if(traitCollection.forceTouchCapability == .available){
            registerForPreviewing(with: self, sourceView: self.companyButton)
        }


        nameLabel.text = job.name
        companyButton.setTitle(job.company.name, for: .normal)
        
        typeLabel.text = job.type
        salaryLabel.text = job.salary
        locationNameLabel.text = job.locationName
        descriptionLabel.text = job.description
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowCompany" {
            if let vc = segue.destination as? CompanyViewController {
                vc.company = job.company
            }
        }
    }
    
    
    @IBAction func companyTap(_ sender: Any) {
        performSegue(withIdentifier: "ShowCompany", sender: self)
    }

}

extension JobViewController: UIViewControllerPreviewingDelegate {
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        
        var detailVC: UIViewController!
        detailVC = storyboard?.instantiateViewController(withIdentifier: "CompanyViewController")
        (detailVC as! CompanyViewController).company = job.company
        
        //        detailVC.preferredContentSize = CGSize(width: 0.0, height: 300)
        previewingContext.sourceRect = companyButton.frame
        
        return detailVC
        
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        show(viewControllerToCommit, sender: self)
    }
    
}
