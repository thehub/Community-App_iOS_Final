//
//  CompanyAboutViewModel.swift
//  ImpactHub
//
//  Created by Niklas Alvaeus on 19/05/2017.
//  Copyright © 2017 Lightful Ltd. All rights reserved.
//

import UIKit

class CompanyAboutViewModel: CellRepresentable {
    
    static var cellIdentifier = "CompanyAboutCell"
    
    var company: Company
    
    init(company: Company, cellSize: CGSize) {
        self.company = company
        self.cellSize = cellSize
    }
    
    var jobDescriptionLong: String {
        return "\(company.sector)"
    }
    
    var locationNameLong: String {
        return "\(company.locationName)"
    }
    
    
    func cellInstance(_ collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CompanyAboutViewModel.cellIdentifier, for: indexPath) as! CompanyAboutCell
        cell.setup(vm: self)
        return cell
    }
    
    var cellSize: CGSize
}

