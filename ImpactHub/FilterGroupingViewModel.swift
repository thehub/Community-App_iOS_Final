//
//  JobViewModel.swift
//  ImpactHub
//
//  Created by Niklas Alvaeus on 19/05/2017.
//  Copyright © 2017 Lightful Ltd. All rights reserved.
//

import UIKit

class FilterGroupingViewModel: CellRepresentable {
    
    static var cellIdentifier = "FilterGroupingCell"
    
    var grouping: Filter.Grouping
    var hasSome = false
    
    init(grouping: Filter.Grouping, cellSize: CGSize) {
        self.grouping = grouping
        self.cellSize = cellSize
    }

    func cellInstance(_ collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FilterGroupingViewModel.cellIdentifier, for: indexPath) as! FilterGroupingCell
        cell.setUp(vm: self)
        return cell
    }
    
    var cellSize: CGSize
}

