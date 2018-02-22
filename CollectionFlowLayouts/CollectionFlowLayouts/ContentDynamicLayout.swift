//
//  ContentDynamicLayout.swift
//  collection_view_test
//
//  Created by sergey on 2/12/18.
//  Copyright © 2018 rubygarage. All rights reserved.
//

import UIKit

protocol ContentDynamicLayoutDelegate {
    func cellSize(indexPath: IndexPath) -> CGSize
}

enum DynamicContentAlign {
    case left
    case right
}

struct ItemsPadding {
    var horizontal: CGFloat = 0
    var vertical: CGFloat = 0
    
    static var zero: ItemsPadding {
        return ItemsPadding()
    }
}

class ContentDynamicLayout: UICollectionViewFlowLayout {
    var cachedLayoutAttributes = [UICollectionViewLayoutAttributes]()
    
    var contentAlign: DynamicContentAlign = .left
    var contentPadding: ItemsPadding = .zero
    var cellsPadding: ItemsPadding = .zero
    var delegate: ContentDynamicLayoutDelegate! = nil
    var contentSize: CGSize = .zero
    
    // MARK: - override
    
    override func prepare() {
        super.prepare()
        
        cachedLayoutAttributes.removeAll()
        
        calculateCollectionViewCellsFrames()
    }
    
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var layoutAttributes = [UICollectionViewLayoutAttributes]()
        for attributes in cachedLayoutAttributes {
            if attributes.frame.intersects(rect) {
                layoutAttributes.append(attributes)
            }
        }
        return layoutAttributes
    }

    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return cachedLayoutAttributes.first { attributes -> Bool in
            return attributes.indexPath == indexPath
        }
    }

    func calculateCollectionViewCellsFrames() {
        // override method to calculate frames
    }
    
    override var collectionViewContentSize: CGSize {
        return contentSize
    }
}
