//
//  500pxStyleFlowLayoutSpec.swift
//  collection_flow_layout_Example
//
//  Created by sergey on 3/19/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Quick
import Nimble
import Fakery
@testable import collection_flow_layout

class Px500StyleFlowLayoutSpec: QuickSpec {
    private let k500PxFlowLayoutMaxItems: UInt32 = 50
    private let k500PxFlowLayoutMinItems: UInt32 = 10
    
    override func spec() {
        let itemsCount = Int(arc4random_uniform(k500PxFlowLayoutMaxItems) + k500PxFlowLayoutMinItems)
        let items = Faker.init().lorem.words(amount: itemsCount).components(separatedBy: .whitespaces)
        
        describe("Check 500px style flow layout") {
            it("should have default values") {
                let px500FlowLayout = Px500StyleFlowLayout()
                
                expect(px500FlowLayout.contentAlign).to(beAKindOf(DynamicContentAlign.self))
                expect(px500FlowLayout.contentAlign).to(equal(DynamicContentAlign.left))
                expect(px500FlowLayout.contentAlign).notTo(equal(DynamicContentAlign.right))
                
                expect(px500FlowLayout.cellsPadding).to(beAKindOf(ItemsPadding.self))
                expect(px500FlowLayout.cellsPadding.horizontal).to(equal(0))
                expect(px500FlowLayout.cellsPadding.vertical).to(equal(0))
                
                expect(px500FlowLayout.contentPadding).to(beAKindOf(ItemsPadding.self))
                expect(px500FlowLayout.contentPadding.horizontal).to(equal(0))
                expect(px500FlowLayout.contentPadding.vertical).to(equal(0))
                
                expect(px500FlowLayout.contentSize).to(beAKindOf(CGSize.self))
                
                px500FlowLayout.calculateCollectionViewCellsFrames()
                
                expect(px500FlowLayout.cachedLayoutAttributes.count).to(equal(0))
                
                expect(px500FlowLayout.collectionView).to(beNil())
                expect(px500FlowLayout.delegate).to(beNil())
            }
        }
        
        describe("Check 500px style flow layout with default settings") {
            let px500FlowLayout = self.configure500PxFlowLayout(items: items)
            let attributes = px500FlowLayout.cachedLayoutAttributes

            it("should have every cell valid width") {
                for attr in attributes {
                    expect(attr.frame.size.width).to(beLessThanOrEqualTo(UIScreen.main.bounds.width))
                }
            }            
        }
    }
    
    private func configure500PxFlowLayout(contentPadding: ItemsPadding = ItemsPadding(), cellsPadding: ItemsPadding = ItemsPadding(), align: DynamicContentAlign = .left, items: [String]) -> Px500StyleFlowLayout {
        let flowDelegate = Px500FlowDelegateMock(items: items)
        let px500FlowLayout = Px500StyleFlowLayout()
        px500FlowLayout.delegate = flowDelegate
        
        px500FlowLayout.contentPadding = contentPadding
        px500FlowLayout.cellsPadding = cellsPadding
        px500FlowLayout.contentAlign = align
        
        let dataSource = ContentDataSource()
        dataSource.items = items
        
        let collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height), collectionViewLayout: px500FlowLayout)
        collectionView.dataSource = dataSource
        
        px500FlowLayout.calculateCollectionViewCellsFrames()
        
        expect(px500FlowLayout.collectionView).notTo(beNil())
        
        _ = flowDelegate.cellSize(indexPath: IndexPath(row: 0, section: 0))
        expect(flowDelegate.isCellSizeWasCalled).to(beTrue())
        
        expect(px500FlowLayout.delegate).notTo(beNil())
        expect(px500FlowLayout.delegate).to(beAKindOf(ContentDynamicLayoutDelegate.self))
        
        return px500FlowLayout
    }
}
