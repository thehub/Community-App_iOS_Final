//
//  MemberDetailTopViewModel.swift
//  ImpactHub
//
//  Created by Niklas on 18/05/2017.
//  Copyright © 2017 Lightful Ltd. All rights reserved.
//

import UIKit

class CompanyDetailTopViewModel: CellRepresentable {
    
    static var cellIdentifier = "CompanyDetailTopCell"
    
    var company: Company
    
    var cellBackDelegate: CellBackDelegate?

    init(company: Company, cellBackDelegate: CellBackDelegate, cellSize: CGSize) {
        self.cellBackDelegate = cellBackDelegate
        self.company = company
        self.cellSize = cellSize
    }
    
    func cellInstance(_ collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CompanyDetailTopViewModel.cellIdentifier, for: indexPath) as! CompanyDetailTopCell
        cell.setup(vm: self)
        return cell
    }
    
    var cellSize: CGSize
}
