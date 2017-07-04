//
//  MemberFeedItemViewModel.swift
//  ImpactHub
//
//  Created by Niklas on 18/05/2017.
//  Copyright © 2017 Lightful Ltd. All rights reserved.
//

import UIKit

class MemberFeedItemViewModel: CellRepresentable {
    
    static var cellIdentifier = "MemberFeedItemCell"

    var member: Member // TODO: Remove this it's for mocking only...
    var post: Post
    var comment: Comment?
    var delegate: MemberFeedItemDelegate?
    var feedText = "Lorem ipsum dolor sit amet, habitasse a suspendisse et, nec suscipit imperdiet sed, libero mollis felis egestas vivamus velit."
    
    init(post: Post, member: Member, comment: Comment?, delegate: MemberFeedItemDelegate?, cellSize: CGSize) {
        self.post = post
        self.comment = comment
        self.member = member
        self.delegate = delegate
        self.cellSize = cellSize
    }
    
    
    func cellInstance(_ collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MemberFeedItemViewModel.cellIdentifier, for: indexPath) as! MemberFeedItemCell
        cell.setUp(vm: self)
        return cell
    }
    
    var cellSize: CGSize // 115
}
