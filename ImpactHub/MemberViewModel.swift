//
//  MemberViewModel.swift
//  ImpactHub
//
//  Created by Niklas on 17/05/2017.
//  Copyright © 2017 Lightful Ltd. All rights reserved.
//

import UIKit

class MemberViewModel: CellRepresentable {

    var member: Member
    
    init(member: Member) {
        self.member = member
    }
    
    func cellInstance(_ collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MemberCell", for: indexPath) as! MemberCollectionViewCell
        cell.setup(vm: self)
        return cell
    }
    
    var rowHeight: CGFloat = 200
}
