//
//  JobViewModel.swift
//  ImpactHub
//
//  Created by Niklas Alvaeus on 19/05/2017.
//  Copyright © 2017 Lightful Ltd. All rights reserved.
//

import UIKit

class RelatedViewModel: CellRepresentable {
    
    static var cellIdentifier = "RelatedCell"

    
    var job: Job?
    var project: Project?
    
    init(job: Job, cellSize: CGSize) {
        self.job = job
        self.cellSize = cellSize
    }

    init(project: Project, cellSize: CGSize) {
        self.project = project
        self.cellSize = cellSize
    }

    
    func cellInstance(_ collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RelatedViewModel.cellIdentifier, for: indexPath) as! RelatedCell
        cell.setUp(vm: self)
        return cell
    }
    
    var cellSize: CGSize
}

