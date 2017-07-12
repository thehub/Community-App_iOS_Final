//
//  NotificationViewModel.swift
//  ImpactHub
//
//  Created by Niklas on 12/07/2017.
//  Copyright © 2017 Lightful Ltd. All rights reserved.
//

import UIKit

class NotificationViewModel: CellRepresentable {
    
    static var cellIdentifier = "NotificationCell"
    
    var pushNotification: PushNotification
    
    init(pushNotification: PushNotification, cellSize: CGSize) {
        self.pushNotification = pushNotification
        self.cellSize = cellSize
    }
    
    
    func cellInstance(_ collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NotificationViewModel.cellIdentifier, for: indexPath) as! NotificationCell
        cell.setUp(vm: self)
        return cell
    }
    
    var cellSize: CGSize
}
