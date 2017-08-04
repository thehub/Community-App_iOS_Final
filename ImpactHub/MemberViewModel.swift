//
//  MemberViewModel.swift
//  ImpactHub
//
//  Created by Niklas on 17/05/2017.
//  Copyright © 2017 Lightful Ltd. All rights reserved.
//

import UIKit

class MemberViewModel: CellRepresentable {
    
    static var cellIdentifier = "MemberCollectionViewCell"

    var member: Member
    weak var delegate: MemberCollectionViewCellDelegate?
    
    init(member: Member, delegate: MemberCollectionViewCellDelegate?, cellSize: CGSize) {
        self.member = member
        self.delegate = delegate
        self.cellSize = cellSize
    }
    
    
    func cellInstance(_ collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MemberViewModel.cellIdentifier, for: indexPath) as! MemberCollectionViewCell
        cell.setUp(vm: self)
        return cell
    }
    
    var cellSize: CGSize
}
