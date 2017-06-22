//
//  MemberDetailTopViewModel.swift
//  ImpactHub
//
//  Created by Niklas on 18/05/2017.
//  Copyright © 2017 Lightful Ltd. All rights reserved.
//

import UIKit

class GroupDetailTopViewModel: CellRepresentable {
    
    static var cellIdentifier = "GroupDetailTopCell"
    
    var group: Group
    
    init(group: Group, cellSize: CGSize) {
        self.group = group
        self.cellSize = cellSize
    }
    
//    var jobDescriptionLong: String {
//        return "Consultant at \(member.job)"
//    }
//    
//    var locationNameLong: String {
//        return "Currently working in \(member.locationName)"
//    }
    
    
    func cellInstance(_ collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GroupDetailTopViewModel.cellIdentifier, for: indexPath) as! GroupDetailTopCell
        cell.setup(vm: self)
        return cell
    }
    
    var cellSize: CGSize
}
