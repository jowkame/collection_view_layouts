//
//  InstagramStyleFlowLayuout.swift
//  collection_flow_layout
//
//  Created by sergey on 3/21/18.
//

import UIKit

public enum GridType {
    case defaultGrid
    case onePreviewCell
    case regularPreviewCell
}

public class InstagramStyleFlowLayout: ContentDynamicLayout {
    public var gridType: GridType = .regularPreviewCell
    
    override public func calculateCollectionViewCellsFrames() {
        guard collectionView != nil, delegate != nil else {
            return
        }
        
        if gridType == .defaultGrid {
            calculateDefaultGridCellFrame()
        } else if gridType == .onePreviewCell {
            calculateOnePreviewGridCellFrame()
        } else if gridType == .regularPreviewCell {
            calculateRegularPreviewCellFrame()
        }
    }
    
    private func calculateDefaultGridCellFrame() {
        let itemsCount = collectionView!.numberOfItems(inSection: 0)
        let collectionViewWidth = collectionView!.frame.width
        
        let cellHeight = collectionViewWidth / 3
        var yOffset: CGFloat = 0
        
        for item in 0 ..< itemsCount {
            let indexPath = IndexPath(item: item, section: 0)
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            
            let x = CGFloat(indexPath.row % 3) * cellHeight
            attributes.frame = CGRect(x: x, y: yOffset, width: cellHeight, height: cellHeight)
            
            if indexPath.row % 3 == 2 {
                yOffset += cellHeight
            }
            
            addCachedLayoutAttributes(attributes: attributes)
        }
        
        contentSize.width = collectionViewWidth
        
        let addHeight = (itemsCount % 3) > 0 ? cellHeight : 0
        contentSize.height = CGFloat(itemsCount / 3) * cellHeight + addHeight
    }
    
    private func calculateOnePreviewGridCellFrame() {
        let itemsCount = collectionView!.numberOfItems(inSection: 0)
        let collectionViewWidth = collectionView!.frame.width
        
        let cellHeight = collectionViewWidth / 3
        var yOffset: CGFloat = 2 * cellHeight
        
        for item in 0 ..< itemsCount {
            let indexPath = IndexPath(item: item, section: 0)
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            
            if indexPath.row == 0 {
                attributes.frame = CGRect(x: 0, y: 0, width: cellHeight, height: cellHeight)
            } else if indexPath.row == 1 {
                let bottomFrame = CGRect(x: 0, y: cellHeight, width: cellHeight, height: cellHeight)
                let rightFrame = CGRect(x: cellHeight, y: 0, width: cellHeight, height: cellHeight)
                attributes.frame = (itemsCount == 2) ? rightFrame : bottomFrame
            } else if indexPath.row == 2 {
                attributes.frame = CGRect(x: cellHeight, y: 0, width: cellHeight * 2, height: cellHeight * 2)
            } else {
                let x = CGFloat(indexPath.row % 3) * cellHeight
                attributes.frame = CGRect(x: x, y: yOffset, width: cellHeight, height: cellHeight)
                
                if indexPath.row % 3 == 2 {
                    yOffset += cellHeight
                }
            }
            
            addCachedLayoutAttributes(attributes: attributes)
        }
        
        contentSize.width = collectionView!.frame.size.width
        
        let addHeight = (itemsCount % 3) > 0 ? cellHeight : 0
        contentSize.height = yOffset + addHeight
    }
    
    private func calculateRegularPreviewCellFrame() {
        let itemsCount = collectionView!.numberOfItems(inSection: 0)
        let collectionViewWidth = collectionView!.frame.width
        
        let cellHeight = collectionViewWidth / 3
        var yOffset: CGFloat = 0
        
        var section: Int = 0
        var rowCount: Int = 0
        
        for item in 0 ..< itemsCount {
            let indexPath = IndexPath(item: item, section: 0)
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            
            if section % 4 == 0 {
                calculateRightPreviewSection(attributes: attributes, indexPath: indexPath, cellHeight: cellHeight, section: &section, yOffset: &yOffset)
            } else if section % 4 == 1 || section % 4 == 3 {
                calculateDefaultSection(attributes: attributes, indexPath: indexPath, rowCount: &rowCount, cellHeight: cellHeight, section: &section, yOffset: &yOffset)
            } else if section % 4 == 2 {
                calculateLeftPreviewSection(attributes: attributes, indexPath: indexPath, cellHeight: cellHeight, section: &section, yOffset: &yOffset)
            }
            
            addCachedLayoutAttributes(attributes: attributes)
        }
        
        contentSize.width = collectionView!.frame.size.width
        
        contentSize.height = yOffset
    }
    
    private func calculateRightPreviewSection(attributes: UICollectionViewLayoutAttributes, indexPath: IndexPath, cellHeight: CGFloat,  section: inout Int, yOffset: inout CGFloat) {
        let itemsCount = collectionView!.numberOfItems(inSection: 0)

        if indexPath.row % 3 == 0 {
            attributes.frame = CGRect(x: 0, y: yOffset, width: cellHeight, height: cellHeight)
            yOffset = (indexPath.row + 1 == itemsCount) ? yOffset + cellHeight : yOffset
        } else if indexPath.row % 3 == 1 {
            let bottomFrame = CGRect(x: 0, y: yOffset + cellHeight, width: cellHeight, height: cellHeight)
            let rightFrame = CGRect(x: cellHeight, y: yOffset, width: cellHeight, height: cellHeight)
            attributes.frame = (indexPath.row + 1 == itemsCount) ? rightFrame : bottomFrame
            
            yOffset += cellHeight
        } else if indexPath.row % 3 == 2 {
            yOffset -= cellHeight
            attributes.frame = CGRect(x: cellHeight, y: yOffset, width: cellHeight * 2, height: cellHeight * 2)
            section += 1
            yOffset += 2 * cellHeight
        }
    }
    
    private func calculateDefaultSection(attributes: UICollectionViewLayoutAttributes, indexPath: IndexPath, rowCount: inout Int, cellHeight: CGFloat,  section: inout Int, yOffset: inout CGFloat) {
        let itemsCount = collectionView!.numberOfItems(inSection: 0)

        let x = CGFloat(indexPath.row % 3) * cellHeight
        attributes.frame = CGRect(x: x, y: yOffset, width: cellHeight, height: cellHeight)
        
        if indexPath.row % 3 == 2 {
            yOffset += cellHeight
            rowCount += 1
        }
        
        if rowCount == 2 {
            rowCount = 0
            section += 1
        }
        
        yOffset = (indexPath.row + 1 == itemsCount && indexPath.row % 3 != 2) ? yOffset + cellHeight : yOffset
    }
    
    private func calculateLeftPreviewSection(attributes: UICollectionViewLayoutAttributes, indexPath: IndexPath, cellHeight: CGFloat,  section: inout Int, yOffset: inout CGFloat) {
        let itemsCount = collectionView!.numberOfItems(inSection: 0)

        if indexPath.row % 3 == 0 {
            let bigFrame = CGRect(x: 0, y: yOffset, width: cellHeight * 2, height: cellHeight * 2)
            let smallFrame = CGRect(x: 0, y: yOffset, width: cellHeight, height: cellHeight)
            
            let updatedIndex = indexPath.row + 1
            attributes.frame = (updatedIndex == itemsCount || updatedIndex == itemsCount - 1) ? smallFrame : bigFrame
            
            yOffset = (indexPath.row + 1 == itemsCount) ? yOffset + cellHeight : yOffset
        } else if indexPath.row % 3 == 1 {
            let centralFrame = CGRect(x: cellHeight, y: yOffset, width: cellHeight, height: cellHeight)
            let rightFrame = CGRect(x: cellHeight * 2, y: yOffset, width: cellHeight, height: cellHeight)
            
            attributes.frame = (indexPath.row + 1 == itemsCount) ? centralFrame : rightFrame
            
            yOffset += cellHeight
        } else if indexPath.row % 3 == 2 {
            attributes.frame = CGRect(x: cellHeight * 2, y: yOffset, width: cellHeight, height: cellHeight)
            section += 1
            yOffset += cellHeight
        }
    }
}
