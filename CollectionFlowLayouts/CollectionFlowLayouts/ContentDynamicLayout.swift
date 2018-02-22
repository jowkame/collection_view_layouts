//
//  ContentDynamicLayout.swift
//  collection_view_test
//
//  Created by sergey on 2/12/18.
//  Copyright © 2018 rubygarage. All rights reserved.
//

import UIKit

public protocol ContentDynamicLayoutDelegate: class {
    func cellSize(indexPath: IndexPath) -> CGSize
}

public enum DynamicContentAlign {
    case left
    case right
}

public struct ItemsPadding {
    var horizontal: CGFloat = 0
    var vertical: CGFloat = 0

    static var zero: ItemsPadding {
        return ItemsPadding()
    }
}

public class ContentDynamicLayout: UICollectionViewFlowLayout {
    var cachedLayoutAttributes = [UICollectionViewLayoutAttributes]()
    public var contentAlign: DynamicContentAlign = .left
    public var contentPadding: ItemsPadding = .zero
    public var cellsPadding: ItemsPadding = .zero
    public weak var delegate: ContentDynamicLayoutDelegate! = nil
    public var contentSize: CGSize = .zero

    override public func prepare() {
        super.prepare()

        cachedLayoutAttributes.removeAll()
        calculateCollectionViewCellsFrames()
    }

    override public func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var layoutAttributes = [UICollectionViewLayoutAttributes]()
        for attributes in cachedLayoutAttributes {
            if attributes.frame.intersects(rect) {
                layoutAttributes.append(attributes)
            }
        }
        return layoutAttributes
    }

    override public func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return cachedLayoutAttributes.first { attributes -> Bool in
            return attributes.indexPath == indexPath
        }
    }

    func calculateCollectionViewCellsFrames() {
        // override method to calculate frames
    }

    override public var collectionViewContentSize: CGSize {
        return contentSize
    }
}
