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
    
    var skill: Member.Skill
    
    init(skill: Member.Skill, cellSize: CGSize) {
        self.skill = skill
        self.cellSize = cellSize
    }
    
    
    func cellInstance(_ collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MemberSkillItemViewModel.cellIdentifier, for: indexPath) as! MemberSkillItemCell
        cell.setUp(vm: self)
        return cell
    }
    
    var cellSize: CGSize // 115
}
