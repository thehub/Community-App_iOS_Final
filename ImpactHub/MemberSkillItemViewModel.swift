//
//  MemberSkillItemViewModel.swift
//  ImpactHub
//
//  Created by Niklas on 22/05/2017.
//  Copyright © 2017 Lightful Ltd. All rights reserved.
//

import UIKit

class MemberSkillItemViewModel: CellRepresentable {
    
    static var cellIdentifier = "MemberSkillItemCell"
    
    var member: Member
    
    init(member: Member, cellSize: CGSize) {
        self.member = member
        self.cellSize = cellSize
    }
    
    
    func cellInstance(_ collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MemberSkillItemViewModel.cellIdentifier, for: indexPath) as! MemberSkillItemCell
        cell.setUp(vm: self)
        return cell
    }
    
    var cellSize: CGSize // 115
}
