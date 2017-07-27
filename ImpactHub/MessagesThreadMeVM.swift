//
//  MessagesThreadMeVM.swift
//  ImpactHub
//
//  Created by Niklas Alvaeus on 06/06/2017.
//  Copyright © 2017 Lightful Ltd. All rights reserved.
//

import UIKit

class MessagesThreadMeVM: TableCellRepresentable {
    
    static var cellIdentifier = "MeCell"
    
    var message: Message
    var corners: UIRectCorner
    
    init(message: Message, cellSize: CGSize, corners: UIRectCorner) {
        self.message = message
        self.corners = corners
        self.cellSize = cellSize
    }
    
    
    func cellInstance(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MessagesThreadMeVM.cellIdentifier, for: indexPath) as! MessageThreadMeCell
        cell.setUp(vm: self)
        return cell
        
    }
    
    
    var cellSize: CGSize
    
}

