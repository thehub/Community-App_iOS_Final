//
//  JobViewModel.swift
//  ImpactHub
//
//  Created by Niklas Alvaeus on 19/05/2017.
//  Copyright © 2017 Lightful Ltd. All rights reserved.
//

import UIKit

class EventDetailViewModel: CellRepresentable {
    
    static var cellIdentifier = "EventDetailCell"
    
    var event: Event
    
    weak var eventDetailCellDelegate: EventDetailCellDelegate?
    
    init(event: Event, cellSize: CGSize, eventDetailCellDelegate: EventDetailCellDelegate) {
        self.event = event
        self.cellSize = cellSize
        self.eventDetailCellDelegate = eventDetailCellDelegate
    }
    
    
    func cellInstance(_ collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EventDetailViewModel.cellIdentifier, for: indexPath) as! EventDetailCell
        cell.setUp(vm: self)
        return cell
    }
    
    var cellSize: CGSize
}

