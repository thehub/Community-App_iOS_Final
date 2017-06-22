//
//  ProjectViewModel.swift
//  ImpactHub
//
//  Created by Niklas on 19/06/2017.
//  Copyright © 2017 Lightful Ltd. All rights reserved.
//

import UIKit

class EventViewModel: CellRepresentable {
    
    static var cellIdentifier = "EventCollectionViewCell"
    
    var event: Event
    
    init(event: Event, cellSize: CGSize) {
        self.event = event
        self.cellSize = cellSize
    }
    
    
    func cellInstance(_ collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EventViewModel.cellIdentifier, for: indexPath) as! EventCollectionViewCell
        cell.setUp(vm: self)
        return cell
    }
    
    var cellSize: CGSize
}

