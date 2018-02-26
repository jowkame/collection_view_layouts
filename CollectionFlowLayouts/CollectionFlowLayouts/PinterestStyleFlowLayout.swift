//
//  PinterestStyleLayout.swift
//  collection_view_test
//
//  Created by sergey on 2/21/18.
//  Copyright © 2018 rubygarage. All rights reserved.
//

import UIKit

public class PinterestStyleFlowLayout: ContentDynamicLayout {
    private var previousCellsYOffset = [CGFloat]()

    public var columnsCount: Int = 2

    override func calculateCollectionViewCellsFrames() {
        contentSize.width = collectionView?.frame.size.width ?? 0

        var currentColumnIndex: Int = 0

        previousCellsYOffset = [CGFloat](repeating: contentPadding.vertical, count: columnsCount)

        for item in 0 ..< (collectionView?.numberOfItems(inSection: 0) ?? 0) {
            let cellWidth = calculateCellWidth()

            let indexPath = IndexPath(item: item, section: 0)

            let cellSize = delegate?.cellSize(indexPath: indexPath)

            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            attributes.frame.size = delegate?.cellSize(indexPath: indexPath) ?? .zero
            attributes.frame.size.width = cellWidth

            let minOffsetInfo = minYOffsetFrom(array: previousCellsYOffset)
            attributes.frame.origin.y = minOffsetInfo.offset

            currentColumnIndex = minOffsetInfo.index

            attributes.frame.origin.x = CGFloat(currentColumnIndex) * (cellWidth + cellsPadding.horizontal) + contentPadding.horizontal

            previousCellsYOffset[currentColumnIndex] = (cellSize?.height ?? 0) + previousCellsYOffset[currentColumnIndex] + cellsPadding.vertical

            cachedLayoutAttributes.append(attributes)
        }

        contentSize.height = (previousCellsYOffset.max() ?? 0) + contentPadding.vertical - cellsPadding.vertical
    }

    private func minYOffsetFrom(array: [CGFloat]) -> (offset: CGFloat, index: Int) {
        let minYOffset = array.min() ?? 0
        let minIndex = array.index(of: minYOffset) ?? 0

        return (minYOffset, minIndex)
    }

    private func calculateCellWidth() -> CGFloat {
        let collectionViewWidth = collectionView?.frame.size.width ?? 0
        let innerCellsPading = CGFloat(columnsCount - 1) * cellsPadding.horizontal
        let contentWidth = collectionViewWidth - 2 * contentPadding.horizontal - innerCellsPading

        return contentWidth / CGFloat(columnsCount)
    }
}
