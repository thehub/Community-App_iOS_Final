//
//  MemberViewModel.swift
//  ImpactHub
//
//  Created by Niklas on 17/05/2017.
//  Copyright © 2017 Lightful Ltd. All rights reserved.
//

import UIKit

class ContactViewModel: CellRepresentable {
    
    static var cellIdentifier = "ContactCell"

    var member: Member
    weak var contactCellDelegate: ContactCellDelegate?

    init(member: Member, contactCellDelegate: ContactCellDelegate, cellSize: CGSize) {
        self.member = member
        self.contactCellDelegate = contactCellDelegate
        self.cellSize = cellSize
    }
    
    
    func cellInstance(_ collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ContactViewModel.cellIdentifier, for: indexPath) as! ContactCell
        cell.setUp(vm: self)
        return cell
    }
    
    var cellSize: CGSize
}
