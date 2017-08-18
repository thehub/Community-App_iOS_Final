//
//  MemberDetailTopViewModel.swift
//  ImpactHub
//
//  Created by Niklas on 18/05/2017.
//  Copyright © 2017 Lightful Ltd. All rights reserved.
//

import UIKit

class MemberDetailTopViewModel: CellRepresentable {
    
    static var cellIdentifier = "MemberDetailTopCell"
    
    var member: Member
    
    var cellBackDelegate: CellBackDelegate?

    init(member: Member, cellBackDelegate: CellBackDelegate, cellSize: CGSize) {
        self.cellBackDelegate = cellBackDelegate
        self.member = member
        self.cellSize = cellSize
    }
    
    
    var locationNameLong: String {
        return "\(member.locationName)"
    }
    
    
    func cellInstance(_ collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MemberDetailTopViewModel.cellIdentifier, for: indexPath) as! MemberDetailTopCell
        cell.setup(vm: self)
        return cell
    }
    
    var cellSize: CGSize
}
