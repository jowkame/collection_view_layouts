//
//  500pxStyleFlowLayout.swift
//  collection_flow_layout
//
//  Created by sergey on 3/14/18.
//

import UIKit

public class Px500StyleFlowLayout: ContentDynamicLayout {
    private let kMinCellsInRow: UInt32 = 1
    private let kMaxCellsInRow: UInt32 = 3
    
    public var visibleRowsCount: Int = 5
    
    override public func calculateCollectionViewCellsFrames() {
        guard let contentCollectionView = collectionView, delegate != nil else {
            return
        }
        
        let itemsCount = contentCollectionView.numberOfItems(inSection: 0)

        var dict = Dictionary<Int, Int>()
        var sum: Int = 0
        var rowCount: Int = 0
        
        while sum < itemsCount {
            let cellsInRowCount = arc4random_uniform(kMaxCellsInRow) + kMinCellsInRow
            sum += Int(cellsInRowCount)
            dict[rowCount] = Int(cellsInRowCount)
            
            rowCount += 1
        }
        
        let cellHeight = collectionView!.frame.height / CGFloat(visibleRowsCount)
        
        var index: Int = 0
        var yOffset: CGFloat = 0
        
        for i in 0..<dict.count - 1 {
            let cellsInRow = dict[i]!
            
            var xOffset: CGFloat = 0
            var cellsWidths = [CGFloat]()
            
            for _ in 0..<cellsInRow  {
                let indexPath = IndexPath(item: index, section: 0)
                let contentSize = delegate!.cellSize(indexPath: indexPath)
                
                cellsWidths.append(contentSize.width)
            }
            
            let cellWidthsPercents = convertCellWidthsToRelative(cellWidths: cellsWidths)
            
            for j in 0..<cellsInRow  {
                let indexPath = IndexPath(item: index, section: 0)
                let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                
                let currentCellWidth = cellWidthsPercents[j]
                attributes.frame = CGRect(x: xOffset, y: yOffset, width: currentCellWidth, height: cellHeight)
                
                addCachedLayoutAttributes(attributes: attributes)
                index += 1
                xOffset += currentCellWidth
            }
            
            
            yOffset += cellHeight
        }
        
        contentSize.width = contentCollectionView.frame.size.width
    }
    
    private func convertCellWidthsToRelative(cellWidths: [CGFloat]) -> [CGFloat] {
        guard let contentCollectionView = collectionView, delegate != nil else {
            return [CGFloat]()
        }
        
        if cellWidths.count == 1 {
            return [contentCollectionView.frame.size.width]
        } else if cellWidths.count == 2 {
            return [CGFloat](repeating: contentCollectionView.frame.size.width / 2, count: 2)
        } else if cellWidths.count == 3 {
            return [CGFloat](repeating: contentCollectionView.frame.size.width / 3, count: 3)
        }
        
        return [CGFloat(0)]
    }
}
