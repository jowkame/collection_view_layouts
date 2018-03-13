//
//  TagsFlowDelegate.swift
//  collection_flow_layout_Example
//
//  Created by sergey on 2/28/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import collection_flow_layout

class TagsFlowDelegateMock: ContentDynamicLayoutDelegate {
    private var items = [String]()
    private var cellSizes = [CGSize]()

    public var isCellSizeWasCalled = false
    
    init(items: [String]) {
        self.items = items
        
        cellSizes = CellSizeProvider.provideSizes(items: items, flowType: .tags)
    }
    
    func cellSize(indexPath: IndexPath) -> CGSize {
        isCellSizeWasCalled = true
        
        return cellSizes[indexPath.row]
    }
}
