//
//  FilterViewModel.swift
//  ImpactHub
//
//  Created by Niklas Alvaeus on 28/06/2017.
//  Copyright © 2017 Lightful Ltd. All rights reserved.
//

import UIKit

class FilterViewModel: CellRepresentable {
    
    static var cellIdentifier = "FilterCell"
    
    var filter: Filter
    
    init(filter: Filter, cellSize: CGSize) {
        self.filter = filter
        self.cellSize = cellSize
    }
    
    func cellInstance(_ collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FilterViewModel.cellIdentifier, for: indexPath) as! FilterCell
        cell.setUp(vm: self)
        return cell
    }
    
    var cellSize: CGSize
}
