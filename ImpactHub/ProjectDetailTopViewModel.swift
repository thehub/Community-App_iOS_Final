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
    var cellBackDelegate: CellBackDelegate?

    
    init(project: Project, cellBackDelegate: CellBackDelegate, cellSize: CGSize) {
        self.cellBackDelegate = cellBackDelegate
        self.project = project
        self.cellSize = cellSize
    }
    
    func cellInstance(_ collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProjectDetailTopViewModel.cellIdentifier, for: indexPath) as! ProjectDetailTopCell
        cell.setup(vm: self)
        return cell
    }
    
    var cellSize: CGSize
}
