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
    
    weak var cellBackDelegate: CellBackDelegate?

    init(member: Member, cellBackDelegate: CellBackDelegate, cellSize: CGSize) {
        self.cellBackDelegate = cellBackDelegate
        self.member = member
        self.cellSize = cellSize
    }
    
    
    var locationNameLong: String {
        return "\(member.impactHubCities?.replacingOccurrences(of: ";", with: ", ") ?? "")"
    }
    
    var jobLabel: String {
        var label: String = member.job
        if let accountName = member.accountName {
            label.append(" at \(accountName)")
        }
        return label
    }
    
    func cellInstance(_ collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MemberDetailTopViewModel.cellIdentifier, for: indexPath) as! MemberDetailTopCell
        cell.setup(vm: self)
        return cell
    }
    
    var cellSize: CGSize
}
