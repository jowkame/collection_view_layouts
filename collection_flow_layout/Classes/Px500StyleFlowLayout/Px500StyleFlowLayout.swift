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
            
            for i in index..<(index + cellsInRow)  {
                let indexPath = IndexPath(item: i, section: 0)
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
        contentSize.height = CGFloat(rowCount - 1) * cellHeight
    }
    
    private func convertCellWidthsToRelative(cellWidths: [CGFloat]) -> [CGFloat] {
        guard let contentCollectionView = collectionView, delegate != nil else {
            return [CGFloat]()
        }
        
        if cellWidths.count == 1 {
            return [contentCollectionView.frame.size.width]
        } else if cellWidths.count == 2 {
            return calculateDoubleCells(cellWidths: cellWidths)
        } else if cellWidths.count == 3 {
//            return [CGFloat](repeating: contentCollectionView.frame.size.width / 3, count: 3)
            return calculateThreeCells(cellWidths: cellWidths)
        }
        
        return [CGFloat(0)]
    }
    
    private func calculateDoubleCells(cellWidths: [CGFloat]) -> [CGFloat] {
        guard let contentCollectionView = collectionView, delegate != nil else {
            return [CGFloat]()
        }
        
        let firstCellWidth = cellWidths[0]
        let secondCellWidth = cellWidths[1]
        
        let halfContentWidth = contentCollectionView.frame.width / 2
        
        let coefficient = firstCellWidth / secondCellWidth
        
        if coefficient < 1 {
            let relativeFirst = halfContentWidth * coefficient
            let relativeSecond = contentCollectionView.frame.size.width - relativeFirst
            return [relativeFirst, relativeSecond]
        } else {
            let relativeFirst = halfContentWidth / coefficient
            let relativeSecond = contentCollectionView.frame.size.width - relativeFirst
            return [relativeSecond, relativeFirst]
        }
    }
    
    private func calculateThreeCells(cellWidths: [CGFloat]) -> [CGFloat] {
        guard let contentCollectionView = collectionView, delegate != nil else {
            return [CGFloat]()
        }
        
        let firstCellWidth = cellWidths[0]
        let secondCellWidth = cellWidths[1]
        let thirdCellWidth = cellWidths[2]
        
        
        
        return [CGFloat](repeating: contentCollectionView.frame.size.width / 3, count: 3)
        
        
    }
    
}
