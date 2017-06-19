//
//  ProjectViewModel.swift
//  ImpactHub
//
//  Created by Niklas on 19/06/2017.
//  Copyright © 2017 Lightful Ltd. All rights reserved.
//

import UIKit

class ProjectViewModel: CellRepresentable {
    
    static var cellIdentifier = "ProjectCollectionViewCell"
    
    var project: Project
    
    init(project: Project, cellSize: CGSize) {
        self.project = project
        self.cellSize = cellSize
    }
    
    
    func cellInstance(_ collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProjectViewModel.cellIdentifier, for: indexPath) as! ProjectCollectionViewCell
        cell.setUp(vm: self)
        return cell
    }
    
    var cellSize: CGSize
}

