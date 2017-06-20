//
//  ProjectObjectiveViewModel.swift
//  ImpactHub
//
//  Created by Niklas Alvaeus on 20/06/2017.
//  Copyright © 2017 Lightful Ltd. All rights reserved.
//

import UIKit

class ProjectObjectiveViewModel: CellRepresentable {
    
    static var cellIdentifier = "ProjectObjectiveCell"
    
    var objective: Project.Objective
    
    init(objective: Project.Objective, cellSize: CGSize) {
        self.objective = objective
        self.cellSize = cellSize
    }
    
    
    func cellInstance(_ collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProjectObjectiveViewModel.cellIdentifier, for: indexPath) as! ProjectObjectiveCell
        cell.setUp(vm: self)
        return cell
    }
    
    var cellSize: CGSize
}
