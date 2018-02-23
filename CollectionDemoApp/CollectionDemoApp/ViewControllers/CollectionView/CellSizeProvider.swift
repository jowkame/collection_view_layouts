//
//  CellSizesProvider.swift
//  CollectionDemoApp
//
//  Created by sergey on 2/23/18.
//  Copyright © 2018 rubygarage. All rights reserved.
//

import UIKit

class CellSizeProvider {
    class func provideSizes(items: [String], flowType: FLowLayoutType) -> [CGSize] {
        var cellSizes = [CGSize]()
        var size: CGSize = .zero
        
        for item in items {
            if flowType == .tags {
                size =  CellSizeProvider.provideTagCellSize(item: item)
            } else if flowType == .pinterest {
                size = CellSizeProvider.providePinterestCellSize(item: item)
            }
            
            cellSizes.append(size)
        }
       
        return cellSizes
    }
    
    private class func provideTagCellSize(item: String) -> CGSize {
        var size = UIFont.systemFont(ofSize: 17).sizeOfString(string: item, constrainedToWidth: 100)
        size.width += 15
        size.height += 15
        
        return size
    }
    
    private class func providePinterestCellSize(item: String) -> CGSize {
        let width = CGFloat(arc4random_uniform(100) + 50)
        let height = CGFloat(arc4random_uniform(100) + 50)
        
        return CGSize(width: width, height: height)
    }
}
