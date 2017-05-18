//
//  CellRepresentable.swift
//  mvvm
//
//  Created by Thomas Degry on 12/16/16.
//  Copyright © 2016 Thomas Degry. All rights reserved.
//

import UIKit

protocol CellRepresentable {
    var cellSize: CGSize { get set }
    func cellInstance(_ collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell
}

