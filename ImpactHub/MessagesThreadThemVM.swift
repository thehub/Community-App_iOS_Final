//
//  MessagesThreadThemVM.swift
//  ImpactHub
//
//  Created by Niklas Alvaeus on 06/06/2017.
//  Copyright © 2017 Lightful Ltd. All rights reserved.
//

import UIKit

class MessagesThreadThemVM: TableCellRepresentable {
    
    static var cellIdentifier = "ThemCell"
    
    var message: Message
    var corners: UIRectCorner
    
    init(message: Message, cellSize: CGSize, corners: UIRectCorner) {
        self.message = message
        self.corners = corners
        self.cellSize = cellSize
    }
    
    
    func cellInstance(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MessagesThreadThemVM.cellIdentifier, for: indexPath) as! MessageThreadThemCell
        cell.setUp(vm: self)
        return cell
        
    }
    
    var cellSize: CGSize
}
