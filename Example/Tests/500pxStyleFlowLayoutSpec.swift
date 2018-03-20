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
            it("should have every cell valid width") {
                let px500FlowLayout = self.configure500PxFlowLayout(items: items)
                let attributes = px500FlowLayout.cachedLayoutAttributes
                
                for attr in attributes {
                    expect(attr.frame.size.width).to(beLessThanOrEqualTo(UIScreen.main.bounds.width))
                }
            }
            
            it("should have every cell valid frame") {
                let items = ["Facebook", "Twitter", "Instagram", "Network", "Framework", "Test"]
                let layoutConfiguration = [0: 1, 1: 2, 2: 3]
                let defaultMaxVisibleRows: Int = 5
                let px500FlowLayout = self.configure500PxFlowLayout(layoutConfiguration: layoutConfiguration, isCellsTransefered: true, items: items)
                let attributes = px500FlowLayout.cachedLayoutAttributes
                
                let firstCellAttributes = attributes[0]
                let secondCellAttributes = attributes[1]
                let thirdCellAttributes = attributes[2]
                let fourthCellAttributes = attributes[3]
                let fifthCellAttributes = attributes[4]
                let sixthCellAttributes = attributes[5]
                
                let screenWidth = UIScreen.main.bounds.width
                let rowHeight = px500FlowLayout.collectionView!.frame.height / CGFloat(defaultMaxVisibleRows)

                expect(firstCellAttributes.frame).to(equal(CGRect(x: 0, y: 0, width: screenWidth, height: rowHeight)))
                expect(secondCellAttributes.frame).to(equal(CGRect(x: 0, y: rowHeight, width: screenWidth / 2, height: rowHeight)))
                expect(thirdCellAttributes.frame).to(equal(CGRect(x: screenWidth / 2, y: rowHeight, width: screenWidth / 2, height: rowHeight)))
                expect(fourthCellAttributes.frame).to(equal(CGRect(x: 0, y: 2 * rowHeight, width: screenWidth / 3, height: rowHeight)))
                expect(fifthCellAttributes.frame).to(equal(CGRect(x: screenWidth / 3, y: 2 * rowHeight, width: screenWidth / 3, height: rowHeight)))
                expect(sixthCellAttributes.frame).to(equal(CGRect(x: (screenWidth / 3) * 2, y: 2 * rowHeight, width: screenWidth / 3, height: rowHeight)))
            }
        }
    }
    
    private func configure500PxFlowLayout(contentPadding: ItemsPadding = ItemsPadding(), layoutConfiguration: Dictionary<Int, Int> = Dictionary<Int, Int>(),  cellsPadding: ItemsPadding = ItemsPadding(), isCellsTransefered: Bool = false, align: DynamicContentAlign = .left, items: [String]) -> Px500StyleFlowLayout {
        let flowDelegate = Px500FlowDelegateMock(items: items)
        let px500FlowLayout = Px500StyleFlowLayout()
        let fiveElementsDelegateMock = Px500FiveElementsDelegateMock()
        px500FlowLayout.delegate = isCellsTransefered ? fiveElementsDelegateMock : flowDelegate
        px500FlowLayout.layoutConfiguration = layoutConfiguration
        
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
        
        return px500FlowLayout
    }
}
