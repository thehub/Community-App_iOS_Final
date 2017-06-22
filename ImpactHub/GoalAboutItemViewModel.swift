//
//  MemberAboutItemViewModel.swift
//  ImpactHub
//
//  Created by Niklas on 18/05/2017.
//  Copyright © 2017 Lightful Ltd. All rights reserved.
//

import UIKit

class GoalAboutItemViewModel: CellRepresentable {
    
    static var cellIdentifier = "GoalAboutItemCell"

    var goal: Goal
    
    init(goal: Goal, cellSize: CGSize) {
        self.goal = goal
        self.cellSize = cellSize
    }
    
    
    func cellInstance(_ collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GoalAboutItemViewModel.cellIdentifier, for: indexPath) as! GoalAboutItemCell
        cell.setUp(vm: self)
        return cell
    }
    
    var cellSize: CGSize // 115
}
