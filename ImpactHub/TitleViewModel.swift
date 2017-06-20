//
//  TitleViewModel.swift
//  ImpactHub
//
//  Created by Niklas Alvaeus on 20/06/2017.
//  Copyright © 2017 Lightful Ltd. All rights reserved.
//

import UIKit

class TitleViewModel: CellRepresentable {
    
    static var cellIdentifier = "TitleCell"
    
    var title: String
    
    init(title: String, cellSize: CGSize) {
        self.title = title
        self.cellSize = cellSize
    }
    
    
    func cellInstance(_ collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TitleViewModel.cellIdentifier, for: indexPath) as! TitleCell
        cell.setUp(vm: self)
        return cell
    }
    
    var cellSize: CGSize
}
