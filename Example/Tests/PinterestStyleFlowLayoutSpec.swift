//
//  PinterestFlowLayoutTest.swift
//  collection_flow_layout_Example
//
//  Created by jowkame on 2/28/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Quick
import Nimble
import Fakery
@testable import collection_flow_layout

class PinterestStyleFlowLayoutSpec: QuickSpec {
    private let kPinterestStyleFlowLayoutMaxItems: UInt32 = 100
    private let kPinterestStyleFlowLayoutMinItems: UInt32 = 10
    
    override func spec() {
        let itemsCount = Int(arc4random_uniform(kPinterestStyleFlowLayoutMaxItems) + kPinterestStyleFlowLayoutMinItems)
        let items = Faker.init().lorem.words(amount: itemsCount).components(separatedBy: .whitespaces)
        
        describe("Check pinterest flow layout") {
            it("pinterest flow layout fields validation") {
                let tagsFlowLayout = self.configurePinterestFlowLayout(items: items)

                expect(tagsFlowLayout.contentAlign).to(beAKindOf(DynamicContentAlign.self))
                expect(tagsFlowLayout.contentAlign).to(equal(DynamicContentAlign.left))

                expect(tagsFlowLayout.cellsPadding).to(beAKindOf(ItemsPadding.self))
                expect(tagsFlowLayout.cellsPadding.horizontal).to(equal(0))
                expect(tagsFlowLayout.cellsPadding.vertical).to(equal(0))

                expect(tagsFlowLayout.contentPadding).to(beAKindOf(ItemsPadding.self))
                expect(tagsFlowLayout.contentPadding.horizontal).to(equal(0))
                expect(tagsFlowLayout.contentPadding.vertical).to(equal(0))

                expect(tagsFlowLayout.contentSize).to(beAKindOf(CGSize.self))

                expect(tagsFlowLayout.delegate).to(beNil())
            }
        }
        
        describe("Check pinterest flow layout") {
            it("pinterest flow layout fields validation") {
                let tagsFlowLayout = self.configurePinterestFlowLayout(items: items)
                let attributes = tagsFlowLayout.cachedLayoutAttributes
                
                var currentColumnCount: Int = 0

                var previousOffsetsDict = Dictionary<Int, CGFloat>()
                
                for attr in attributes {
                    expect(attr.frame.size.width).to(equal(UIScreen.main.bounds.width / CGFloat(tagsFlowLayout.columnsCount)))
                    
                    let columnIndex = attr.indexPath.row % tagsFlowLayout.columnsCount
                    expect(columnIndex).to(equal(currentColumnCount))
                    
                    currentColumnCount = (currentColumnCount < tagsFlowLayout.columnsCount - 1) ? (currentColumnCount + 1) : 0
                    
                    previousOffsetsDict[columnIndex] = attr.frame.origin.y + attr.frame.size.height
                }
            }
        }
    }
    
    private func configurePinterestFlowLayout(contentPadding: ItemsPadding = ItemsPadding(), cellsPadding: ItemsPadding = ItemsPadding(), columnsCount: Int = 2, items: [String]) -> PinterestStyleFlowLayout {
        let flowDelegate = PinterestFlowDelegate(items: items)
        let pinterestFlowLayout = PinterestStyleFlowLayout()
        pinterestFlowLayout.delegate = flowDelegate
        pinterestFlowLayout.contentPadding = contentPadding
        pinterestFlowLayout.cellsPadding = cellsPadding
        
        let dataSource = ContentDataSource()
        dataSource.items = items
        
        let collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height), collectionViewLayout: pinterestFlowLayout)
        collectionView.dataSource = dataSource
        
        pinterestFlowLayout.calculateCollectionViewCellsFrames()
        
        return pinterestFlowLayout
    }
}
