//
//  MemberSkillItemViewModel.swift
//  ImpactHub
//
//  Created by Niklas on 22/05/2017.
//  Copyright © 2017 Lightful Ltd. All rights reserved.
//

import UIKit

class CompanyServiceItemViewModel: CellRepresentable {
    
    static var cellIdentifier = "CompanyServiceItemCell"
    
    var company: Company
    
    init(company: Company, cellSize: CGSize) {
        self.company = company
        self.cellSize = cellSize
    }
    
    
    func cellInstance(_ collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CompanyServiceItemViewModel.cellIdentifier, for: indexPath) as! CompanyServiceItemCell
        cell.setUp(vm: self)
        return cell
    }
    
    var cellSize: CGSize // 115
}
