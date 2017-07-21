//
//  HomeCellViewModel.swift
//  ImpactHub
//
//  Created by Niklas Alvaeus on 21/07/2017.
//  Copyright © 2017 Lightful Ltd. All rights reserved.
//

import UIKit

class HomeCellViewModel: CellRepresentable {
    
    static var cellIdentifier = "HomeCell"
    
    var section: HomeViewController.Section
    
    init(section: HomeViewController.Section, cellSize: CGSize) {
        self.section = section
        self.cellSize = cellSize
    }
    
    
    func cellInstance(_ collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeCellViewModel.cellIdentifier, for: indexPath) as! HomeCell
        cell.setUp(vm: self)
        return cell
    }
    
    var cellSize: CGSize
}
