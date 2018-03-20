//
//  PinterestFiveElementsDelegateMock.swift
//  collection_flow_layout_Example
//
//  Created by sergey on 3/19/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import collection_flow_layout

class Px500FiveElementsDelegateMock: ContentDynamicLayoutDelegate {
    private var cellSizes = [CGSize(width: 100, height: 100), CGSize(width: 100, height: 30), CGSize(width: 100, height: 80), CGSize(width: 100, height: 50), CGSize(width: 100, height: 100), CGSize(width: 100, height: 100)]
    
    func cellSize(indexPath: IndexPath) -> CGSize {
        return cellSizes[indexPath.row]
    }
}
