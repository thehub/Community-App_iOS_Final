//
//  MemberDetailTopViewModel.swift
//  ImpactHub
//
//  Created by Niklas on 18/05/2017.
//  Copyright © 2017 Lightful Ltd. All rights reserved.
//

import UIKit

class GoalDetailTopViewModel: CellRepresentable {
    
    static var cellIdentifier = "GoalDetailTopCell"
    
    var cellBackDelegate: CellBackDelegate?

    var goal: Goal
    
    init(goal: Goal, cellBackDelegate: CellBackDelegate, cellSize: CGSize) {
        self.cellBackDelegate = cellBackDelegate
        self.goal = goal
        self.cellSize = cellSize
    }
    
    func cellInstance(_ collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GoalDetailTopViewModel.cellIdentifier, for: indexPath) as! GoalDetailTopCell
        cell.setup(vm: self)
        return cell
    }
    
    var cellSize: CGSize
}
