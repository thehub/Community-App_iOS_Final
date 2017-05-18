//
//  MemberAboutItemViewModel.swift
//  ImpactHub
//
//  Created by Niklas on 18/05/2017.
//  Copyright © 2017 Lightful Ltd. All rights reserved.
//

import UIKit

class MemberAboutItemViewModel: CellRepresentable {
    
    var member: Member
    
    init(member: Member, cellSize: CGSize) {
        self.member = member
        self.cellSize = cellSize
    }
    
    
    func cellInstance(_ collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MemberAboutItemCell", for: indexPath) as! MemberAboutItemCell
        cell.setUp(vm: self)
        return cell
    }
    
    var cellSize: CGSize // 115
}
