//
//  TestViewController.swift
//  ImpactHub
//
//  Created by Niklas Alvaeus on 20/06/2017.
//  Copyright © 2017 Lightful Ltd. All rights reserved.
//

import UIKit

class TestViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var collectionView: UICollectionView!
    var data = [CellRepresentable]()


    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.register(UINib.init(nibName: ProjectViewModel.cellIdentifier, bundle: nil), forCellWithReuseIdentifier: ProjectViewModel.cellIdentifier)

//        data.append(ProjectViewModel(project: Project(), cellSize: CGSize(width: view.frame.width, height: 370)))
//        
//        data.append(ProjectViewModel(project: Project(), cellSize: CGSize(width: view.frame.width, height: 370)))
//        
//        data.append(ProjectViewModel(project: Project(), cellSize: CGSize(width: view.frame.width, height: 370)))
//        
//        data.append(ProjectViewModel(project: Project(), cellSize: CGSize(width: view.frame.width, height: 370)))
//        
//        data.append(ProjectViewModel(project: Project(), cellSize: CGSize(width: view.frame.width, height: 370)))
//        
//        data.append(ProjectViewModel(project: Project(), cellSize: CGSize(width: view.frame.width, height: 370)))
//        
//        data.append(ProjectViewModel(project: Project(), cellSize: CGSize(width: view.frame.width, height: 370)))
//        
//        data.append(ProjectViewModel(project: Project(), cellSize: CGSize(width: view.frame.width, height: 370)))
//        
//        data.append(ProjectViewModel(project: Project(), cellSize: CGSize(width: view.frame.width, height: 370)))
//        
//        data.append(ProjectViewModel(project: Project(), cellSize: CGSize(width: view.frame.width, height: 370)))
//        
//        data.append(ProjectViewModel(project: Project(), cellSize: CGSize(width: view.frame.width, height: 370)))

        collectionView.delegate = self
        collectionView.dataSource = self
        
        (collectionView.collectionViewLayout as! UICollectionViewFlowLayout).estimatedItemSize = UICollectionViewFlowLayoutAutomaticSize

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        
//        return CGSize(width: view.frame.width, height: 400)
//        
//    }

}

extension TestViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = data[indexPath.item].cellInstance(collectionView, indexPath: indexPath)
        return cell
    }
}
