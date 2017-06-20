//
//  MemberDetailTopViewModel.swift
//  ImpactHub
//
//  Created by Niklas on 18/05/2017.
//  Copyright © 2017 Lightful Ltd. All rights reserved.
//

import UIKit

class ProjectDetailTopViewModel: CellRepresentable {
    
    static var cellIdentifier = "ProjectDetailTopCell"
    
    var project: Project
    
    init(project: Project, cellSize: CGSize) {
        self.project = project
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProjectDetailTopViewModel.cellIdentifier, for: indexPath) as! ProjectDetailTopCell
        cell.setup(vm: self)
        return cell
    }
    
    var cellSize: CGSize
}
