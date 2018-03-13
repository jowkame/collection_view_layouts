//
//  PinterestFlowDelegate.swift
//  collection_flow_layout_Example
//
//  Created by sergey on 2/28/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import collection_flow_layout

class PinterestFlowDelegate: ContentDynamicLayoutDelegate {
    private var items = [String]()
    private var cellSizes = [CGSize]()
   
    init(items: [String]) {
        self.items = items
        
        cellSizes = CellSizeProvider.provideSizes(items: items, flowType: .pinterest)
    }
    
    func cellSize(indexPath: IndexPath) -> CGSize {
        return cellSizes[indexPath.row]
    }
}
