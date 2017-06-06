//
//  MessagesThreadMeVM.swift
//  ImpactHub
//
//  Created by Niklas Alvaeus on 06/06/2017.
//  Copyright © 2017 Lightful Ltd. All rights reserved.
//

import UIKit

class MessagesThreadThemPicVM: TableCellRepresentable {
    
    static var cellIdentifier = "ThemPicCell"
    
    var message: Message
    
    init(message: Message, cellSize: CGSize) {
        self.message = message
        self.cellSize = cellSize
    }
    
    
    func cellInstance(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MessagesThreadThemPicVM.cellIdentifier, for: indexPath) as! MessageThreadThemPicCell
        cell.setUp(vm: self)
        return cell
        
    }
    
    
    var cellSize: CGSize
    
}

