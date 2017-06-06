//
//  MessagesVM.swift
//  ImpactHub
//
//  Created by Niklas Alvaeus on 06/06/2017.
//  Copyright © 2017 Lightful Ltd. All rights reserved.
//

import UIKit

class MessagesVM: CellRepresentable {
    
    static var cellIdentifier = "MessagesCell"
    
    var conversation: Conversation
    
    init(conversation: Conversation, cellSize: CGSize) {
        self.conversation = conversation
        self.cellSize = cellSize
    }
    
    func cellInstance(_ collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MessagesVM.cellIdentifier, for: indexPath) as! MessagesCell
        cell.setUp(vm: self)
        return cell
    }
    
    var cellSize: CGSize
}
