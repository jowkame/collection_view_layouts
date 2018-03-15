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
    private let kCenterWidthMinCoef: CGFloat = 0.2
    private let kCenterWidthMaxCoef: CGFloat = 0.4
    private let kNotCenterWidthMinCoef: CGFloat = 0.22
    private let kNotCenterWidthMaxCoef: CGFloat = 0.39
    private let kFullPercents: CGFloat = 1
    
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
            var cellsSizes = [CGSize]()
            
            for i in index..<(index + cellsInRow)  {
                let indexPath = IndexPath(item: i, section: 0)
                let contentSize = delegate!.cellSize(indexPath: indexPath)
                
                cellsSizes.append(contentSize)
            }
            
            let cellWidthsPercents = convertCellWidthsToRelative(cellsSizes: cellsSizes)
            
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
    
    private func convertCellWidthsToRelative(cellsSizes: [CGSize]) -> [CGFloat] {
        guard let contentCollectionView = collectionView, delegate != nil else {
            return [CGFloat]()
        }
        
        if cellsSizes.count == 1 {
            return [contentCollectionView.frame.size.width]
        } else if cellsSizes.count == 2 {
            return calculateDoubleCells(cellsSizes: cellsSizes)
        } else if cellsSizes.count == 3 {
            return calculateThreeCells(cellsSizes: cellsSizes)
        }
        
        return [CGFloat(0)]
    }
    
    private func calculateDoubleCells(cellsSizes: [CGSize]) -> [CGFloat] {
        guard let contentCollectionView = collectionView, delegate != nil else {
            return [CGFloat]()
        }
        
        let firstCellSize = cellsSizes[0]
        let secondCellSize = cellsSizes[1]
        
        let halfContentWidth = contentCollectionView.frame.width / 2
        
        let coefficient = firstCellSize.width / secondCellSize.width
        
        if coefficient < kFullPercents {
            let relativeFirst = halfContentWidth * coefficient
            let relativeSecond = contentCollectionView.frame.size.width - relativeFirst
            return [relativeFirst, relativeSecond]
        } else {
            let relativeFirst = halfContentWidth / coefficient
            let relativeSecond = contentCollectionView.frame.size.width - relativeFirst
            return [relativeSecond, relativeFirst]
        }
    }
    
    private func calculateThreeCells(cellsSizes: [CGSize]) -> [CGFloat] {
        guard let contentCollectionView = collectionView, delegate != nil else {
            return [CGFloat]()
        }
        
        let firstCellSize = cellsSizes[0]
        let secondCellSize = cellsSizes[1]
        let thirdCellSize = cellsSizes[2]
        
        let isFirstPortrait = firstCellSize.height > firstCellSize.width
        let isSecondPortrait = secondCellSize.height > secondCellSize.width
        let isThirdPortrait = thirdCellSize.height > thirdCellSize.width
        
        var relativeFirstWidth: CGFloat = 0
        var relativeSecondWidth: CGFloat = 0
        var relativeThirdWidth: CGFloat = 0
        
        if isFirstPortrait == true {
            relativeFirstWidth = CGFloat(contentCollectionView.frame.size.width * kNotCenterWidthMinCoef)
            relativeSecondWidth = CGFloat(contentCollectionView.frame.size.width * kNotCenterWidthMaxCoef)
            relativeThirdWidth = CGFloat(contentCollectionView.frame.size.width * kNotCenterWidthMaxCoef)
            
            return [relativeFirstWidth, relativeSecondWidth, relativeThirdWidth]
        } else if isSecondPortrait == true {
            relativeFirstWidth = CGFloat(contentCollectionView.frame.size.width * kCenterWidthMaxCoef)
            relativeSecondWidth = CGFloat(contentCollectionView.frame.size.width * kCenterWidthMinCoef)
            relativeThirdWidth = CGFloat(contentCollectionView.frame.size.width * kCenterWidthMaxCoef)
            
            return [relativeFirstWidth, relativeSecondWidth, relativeThirdWidth]
        } else if isThirdPortrait == true {
            relativeFirstWidth = CGFloat(contentCollectionView.frame.size.width * kNotCenterWidthMaxCoef)
            relativeSecondWidth = CGFloat(contentCollectionView.frame.size.width * kNotCenterWidthMaxCoef)
            relativeThirdWidth = CGFloat(contentCollectionView.frame.size.width * kNotCenterWidthMinCoef)
            
            return [relativeFirstWidth, relativeSecondWidth, relativeThirdWidth]
        } else {
            return [CGFloat](repeating: contentCollectionView.frame.size.width / CGFloat(kMaxCellsInRow), count: Int(kMaxCellsInRow))
        }
    }
}
