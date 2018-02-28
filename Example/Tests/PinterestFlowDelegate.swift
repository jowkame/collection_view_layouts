//
//  PinterestFlowDelegate.swift
//  collection_flow_layout_Example
//
//  Created by sergey on 2/28/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import collection_flow_layout

class PinterestFlowDelegate: ContentDynamicLayoutDelegate {
    private var cellSizes = [CGSize]()
    
    init() {
        cellSizes = [CGSize(width: 52, height: 71), CGSize(width: 116, height: 137), CGSize(width: 70, height: 52), CGSize(width: 123, height: 81), CGSize(width: 116, height: 111), CGSize(width: 90, height: 76), CGSize(width: 57, height: 83), CGSize(width: 93, height: 121)]
    }
    
    func cellSize(indexPath: IndexPath) -> CGSize {
        return cellSizes[indexPath.row]
    }
}
