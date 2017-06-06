//
//  MessagesThreadMeVM.swift
//  ImpactHub
//
//  Created by Niklas Alvaeus on 06/06/2017.
//  Copyright © 2017 Lightful Ltd. All rights reserved.
//

import UIKit

class MessagesThreadThemTimeVM: TableCellRepresentable {
    
    static var cellIdentifier = "ThemTimeCell"
    
    var message: Message
    
    init(message: Message, cellSize: CGSize) {
        self.message = message
        self.cellSize = cellSize
    }
    
    
    func cellInstance(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MessagesThreadThemTimeVM.cellIdentifier, for: indexPath) as! MessageThreadThemTimeCell
        cell.setUp(vm: self)
        return cell
        
    }
    
    
    var cellSize: CGSize
    
}

