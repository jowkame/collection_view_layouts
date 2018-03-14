//
//  500pxStyleFlowLayout.swift
//  collection_flow_layout
//
//  Created by sergey on 3/14/18.
//

import UIKit

public class Px500StyleFlowLayout: ContentDynamicLayout {
    override public func calculateCollectionViewCellsFrames() {
        guard let contentCollectionView = collectionView, delegate != nil else {
            return
        }
        
        contentSize.width = contentCollectionView.frame.size.width
        
        
    }
}

