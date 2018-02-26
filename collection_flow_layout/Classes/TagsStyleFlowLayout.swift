//
//  TagsStyleLayout.swift
//  collection_view_test
//
//  Created by sergey on 2/21/18.
//  Copyright © 2018 rubygarage. All rights reserved.
//

import UIKit

public class TagsStyleFlowLayout: ContentDynamicLayout {
    override func calculateCollectionViewCellsFrames() {
        contentSize.width = collectionView?.frame.size.width ?? 0

        let leftPadding = 0 + contentPadding.horizontal
        let rightPadding = (collectionView?.frame.size.width ?? 0) - contentPadding.horizontal

        var leftMargin: CGFloat = (contentAlign == .left) ? leftPadding : rightPadding

        var topMargin: CGFloat = contentPadding.vertical

        for item in 0 ..< (collectionView?.numberOfItems(inSection: 0) ?? 0) {
            let indexPath = IndexPath(item: item, section: 0)
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)

            attributes.frame.size = delegate?.cellSize(indexPath: indexPath) ?? .zero

            let currentCellWidth = attributes.frame.size.width
            let currentCellHeight = attributes.frame.size.height

            if contentAlign == .left {
                if leftMargin + currentCellWidth + cellsPadding.vertical > collectionView?.frame.size.width ?? 0 {
                    leftMargin = contentPadding.horizontal
                    topMargin += attributes.frame.size.height + cellsPadding.vertical
                }

                attributes.frame.origin.x = leftMargin
                attributes.frame.origin.y = topMargin

                leftMargin += currentCellWidth + cellsPadding.horizontal

            } else if contentAlign == .right {
                if leftMargin - currentCellWidth - cellsPadding.horizontal < 0 {
                    leftMargin = (collectionView?.frame.size.width ?? 0) - contentPadding.horizontal
                    topMargin += attributes.frame.size.height + cellsPadding.vertical
                }

                attributes.frame.origin.x = leftMargin - currentCellWidth
                attributes.frame.origin.y = topMargin

                leftMargin -= currentCellWidth + cellsPadding.horizontal
            }

            addCachedLayoutAttributes(attributes: attributes)

            contentSize.height = topMargin + currentCellHeight + contentPadding.vertical
        }
    }
}
