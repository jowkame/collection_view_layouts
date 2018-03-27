//
//  InstagramStyleBaseDelegateMock.swift
//  collection_flow_layout_Example
//
//  Created by sergey on 3/27/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit
import collection_flow_layout

class InstagramStyleBaseDelegateMock: ContentDynamicLayoutDelegate {
    public var isCellSizeWasCalled = false
    
    func cellSize(indexPath: IndexPath) -> CGSize {
        return .zero
    }
}
