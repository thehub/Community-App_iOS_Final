//
//  MemberViewModel.swift
//  ImpactHub
//
//  Created by Niklas on 17/05/2017.
//  Copyright © 2017 Lightful Ltd. All rights reserved.
//

import UIKit

class GroupViewModel: CellRepresentable {
    
    static var cellIdentifier = "GroupCollectionViewCell"

    var group: Group
    
    init(group: Group, cellSize: CGSize) {
        self.group = group
        self.cellSize = cellSize
    }
    
    
    func cellInstance(_ collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GroupViewModel.cellIdentifier, for: indexPath) as! GroupCollectionViewCell
        cell.setUp(vm: self)
        return cell
    }
    
    var cellSize: CGSize
}
