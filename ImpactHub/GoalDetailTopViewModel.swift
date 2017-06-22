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
    
    var goal: Goal
    
    init(goal: Goal, cellSize: CGSize) {
        self.goal = goal
        self.cellSize = cellSize
    }
    
//    var jobDescriptionLong: String {
//        return "Consultant at \(member.job)"
//    }
//    
//    var locationNameLong: String {
//        return "Currently working in \(member.locationName)"
//    }
    
    
    func cellInstance(_ collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GoalDetailTopViewModel.cellIdentifier, for: indexPath) as! GoalDetailTopCell
        cell.setup(vm: self)
        return cell
    }
    
    var cellSize: CGSize
}
