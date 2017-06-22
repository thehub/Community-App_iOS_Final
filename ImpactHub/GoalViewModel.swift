//
//  GoalViewModel.swift
//  ImpactHub
//
//  Created by Niklas on 19/06/2017.
//  Copyright © 2017 Lightful Ltd. All rights reserved.
//

import UIKit

class GoalViewModel: CellRepresentable {
    
    static var cellIdentifier = "GoalCollectionViewCell"
    
    var goal: Goal
    
    init(goal: Goal, cellSize: CGSize) {
        self.goal = goal
        self.cellSize = cellSize
    }
    
    
    func cellInstance(_ collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GoalViewModel.cellIdentifier, for: indexPath) as! GoalCollectionViewCell
        cell.setUp(vm: self)
        return cell
    }
    
    var cellSize: CGSize
}

