//
//  JobViewModel.swift
//  ImpactHub
//
//  Created by Niklas Alvaeus on 19/05/2017.
//  Copyright © 2017 Lightful Ltd. All rights reserved.
//

import UIKit

class JobDetailViewModel: CellRepresentable {
    
    static var cellIdentifier = "JobDetailCell"

    
    var job: Job
    
    init(job: Job, cellSize: CGSize) {
        self.job = job
        self.cellSize = cellSize
    }
    
    
    func cellInstance(_ collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: JobDetailViewModel.cellIdentifier, for: indexPath) as! JobDetailCell
        cell.setUp(vm: self)
        return cell
    }
    
    var cellSize: CGSize
}

