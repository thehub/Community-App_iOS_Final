//
//  MemberFeedItemViewModel.swift
//  ImpactHub
//
//  Created by Niklas on 18/05/2017.
//  Copyright © 2017 Lightful Ltd. All rights reserved.
//

import UIKit

class MemberFeedItemViewModel: CellRepresentable {
    
    var member: Member
    
    init(member: Member, cellSize: CGSize) {
        self.member = member
        self.cellSize = cellSize
    }
    
    
    func cellInstance(_ collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MemberFeedItemCell", for: indexPath) as! MemberFeedItemCell
        cell.setUp(vm: self)
        return cell
    }
    
    var cellSize: CGSize // 115
}
