//
//  InstagramStyleSingleItemDelegateMock.swift
//  collection_flow_layout_Example
//
//  Created by sergey on 3/27/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit

class InstagramStyleSingleItemDelegateMock: InstagramStyleBaseDelegateMock {
    private var cellSizes = [CGSize]()
    
    override init() {
        cellSizes = [CGSize(width: 50, height: 50)]
    }
    
    override func cellSize(indexPath: IndexPath) -> CGSize {
        isCellSizeWasCalled = true

        return cellSizes[indexPath.row]
    }
}
