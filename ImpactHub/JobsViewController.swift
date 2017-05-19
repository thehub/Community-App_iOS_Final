//
//  JobsViewController.swift
//  ImpactHub
//
//  Created by Niklas Alvaeus on 19/05/2017.
//  Copyright © 2017 Lightful Ltd. All rights reserved.
//

import UIKit

class JobsViewController: UIViewController {

    var data = [CellRepresentable]()

    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib.init(nibName: "JobCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: JobViewModel.cellIdentifier)
        
        
        let company1 = Company(name: "Company 1", type: "Charity", photo: "logo", blurb: "Lorem ipsum dolor sit amet, habitasse a suspendisse et, nec suscipit imperdiet sed, libero mollis felis egestas vivamus velit, felis velit interdum phasellus luctus, nulla molestie felis ligula diam.", locationName: "London", website: "www.dn.se")
        let company2 = Company(name: "Company 2", type: "Sales", photo: "logo", blurb: "Lorem ipsum dolor sit amet, habitasse a suspendisse et, nec suscipit imperdiet sed, libero mollis felis egestas vivamus velit, felis velit interdum phasellus luctus, nulla molestie felis ligula diam.", locationName: "London", website: "www.dn.se")
        let company3 = Company(name: "Company 3", type: "Fashion", photo: "logo", blurb: "Lorem ipsum dolor sit amet, habitasse a suspendisse et, nec suscipit imperdiet sed, libero mollis felis egestas vivamus velit, felis velit interdum phasellus luctus, nulla molestie felis ligula diam.", locationName: "London", website: "www.dn.se")
        let company4 = Company(name: "Company 4", type: "Design", photo: "logo", blurb: "Lorem ipsum dolor sit amet, habitasse a suspendisse et, nec suscipit imperdiet sed, libero mollis felis egestas vivamus velit, felis velit interdum phasellus luctus, nulla molestie felis ligula diam.", locationName: "London", website: "www.dn.se")
        
        
        let item1 = Job(id: "dsfsdf", name: "Marketing Coordinator", company: company1, description: "Lorem ipsum dolor sit amet, habitasse a suspendisse et, nec suscipit imperdiet sed, libero mollis felis egestas vivamus velit", locationName: "Amsterdam / Berlin", type: "Full time", salary: "€30,000 - €40,000 p/a")
        let item2 = Job(id: "dsfassdf", name: "Data Analyst", company: company2, description: "Lorem ipsum dolor sit amet, habitasse a suspendisse et, nec suscipit imperdiet sed, libero mollis felis egestas vivamus velit", locationName: "London", type: "Full time", salary: "€35,000 - €39,000 p/a")
        let item3 = Job(id: "sdsfassdf", name: "Head of CRM", company: company3, description: "Lorem ipsum dolor sit amet, habitasse a suspendisse et, nec suscipit imperdiet sed, libero mollis felis egestas vivamus velit", locationName: "Liverpool", type: "Part time", salary: "€25,000 - €29,000 p/a")
        let item4 = Job(id: "ssdsfassdf", name: "Developer", company: company4, description: "Lorem ipsum dolor sit amet, habitasse a suspendisse et, nec suscipit imperdiet sed, libero mollis felis egestas vivamus velit", locationName: "Budapest", type: "Full time", salary: "€65,000 - €67,000 p/a")
        
        
        let cellWidth: CGFloat = self.view.frame.width - 30
        let viewModel1 = JobViewModel(job: item1, cellSize: CGSize(width: cellWidth, height: 180))
        let viewModel2 = JobViewModel(job: item2, cellSize: CGSize(width: cellWidth, height: 180))
        let viewModel3 = JobViewModel(job: item3, cellSize: CGSize(width: cellWidth, height: 180))
        let viewModel4 = JobViewModel(job: item4, cellSize: CGSize(width: cellWidth, height: 180))
        
        self.data.append(viewModel1)
        self.data.append(viewModel2)
        self.data.append(viewModel3)
        self.data.append(viewModel4)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    var selectedVM: JobViewModel?
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowJob" {
            if let vc = segue.destination as? JobViewController, let selectedItem = selectedVM {
                vc.job = selectedItem.job
            }
        }
    }

}

extension JobsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return data[indexPath.item].cellInstance(collectionView, indexPath: indexPath)
    }
}

extension JobsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let vm = data[indexPath.item] as? JobViewModel {
            selectedVM = vm
            performSegue(withIdentifier: "ShowJob", sender: self)
        }
    }
}

extension JobsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return data[indexPath.item].cellSize
        
    }
}
