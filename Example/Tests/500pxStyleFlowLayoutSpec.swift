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
        
        describe("Check 500px style flow layout with custom settings") {
            it("should have valid outer paddings") {
                let items = ["Facebook", "Twitter", "Instagram", "Network", "Framework", "Test"]
                let layoutConfiguration = [0: 1, 1: 2, 2: 3]
                let defaultMaxVisibleRows: Int = 5
                
                let hPadding: CGFloat = 10
                let vPadding: CGFloat = 10
                let contentPadding = ItemsPadding(horizontal: hPadding, vertical: vPadding)
                
                let px500FlowLayout = self.configure500PxFlowLayout(contentPadding: contentPadding, layoutConfiguration: layoutConfiguration, isCellsTransefered: true, items: items)
                let attributes = px500FlowLayout.cachedLayoutAttributes
                
                let firstCellAttributes = attributes[0]
                let secondCellAttributes = attributes[1]
                let thirdCellAttributes = attributes[2]
                let fourthCellAttributes = attributes[3]
                let fifthCellAttributes = attributes[4]
                let sixthCellAttributes = attributes[5]
                
                let screenWidth = UIScreen.main.bounds.width
                let rowHeight = px500FlowLayout.collectionView!.frame.height / CGFloat(defaultMaxVisibleRows)
                
                expect(firstCellAttributes.frame).to(beCloseTo(CGRect(x: hPadding, y: vPadding, width: screenWidth - 2 * hPadding, height: rowHeight)))
                expect(secondCellAttributes.frame).to(beCloseTo(CGRect(x: hPadding, y: rowHeight + vPadding, width: screenWidth / 2 - hPadding, height: rowHeight)))
                expect(thirdCellAttributes.frame).to(beCloseTo(CGRect(x: screenWidth / 2, y: rowHeight + vPadding, width: screenWidth / 2 - hPadding, height: rowHeight)))
                expect(fourthCellAttributes.frame).to(beCloseTo(CGRect(x: hPadding, y: 2 * rowHeight + vPadding, width: (screenWidth - 2 * hPadding) / 3, height: rowHeight)))
                expect(fifthCellAttributes.frame).to(beCloseTo(CGRect(x: (screenWidth - 2 * hPadding) / 3 + hPadding, y: 2 * rowHeight + vPadding, width: (screenWidth - 2 * hPadding) / 3, height: rowHeight)))
                expect(sixthCellAttributes.frame).to(beCloseTo(CGRect(x: ((screenWidth - 2 * hPadding) / 3) * 2 + hPadding, y: 2 * rowHeight + vPadding, width: (screenWidth - 2 * hPadding) / 3, height: rowHeight)))
            }
            
            it("should have valid inner paddings") {
                let items = ["Facebook", "Twitter", "Instagram", "Network", "Framework", "Test"]
                let layoutConfiguration = [0: 1, 1: 2, 2: 3]
                let defaultMaxVisibleRows: Int = 5
                
                let hPadding: CGFloat = 8
                let vPadding: CGFloat = 8
                let cellsPadding = ItemsPadding(horizontal: hPadding, vertical: vPadding)
                
                let px500FlowLayout = self.configure500PxFlowLayout(layoutConfiguration: layoutConfiguration, cellsPadding: cellsPadding, isCellsTransefered: true, items: items)
                let attributes = px500FlowLayout.cachedLayoutAttributes
                
                let firstCellAttributes = attributes[0]
                let secondCellAttributes = attributes[1]
                let thirdCellAttributes = attributes[2]
                let fourthCellAttributes = attributes[3]
                let fifthCellAttributes = attributes[4]
                let sixthCellAttributes = attributes[5]
                
                let screenWidth = UIScreen.main.bounds.width
                let rowHeight = px500FlowLayout.collectionView!.frame.height / CGFloat(defaultMaxVisibleRows)
                
                expect(firstCellAttributes.frame).to(beCloseTo(CGRect(x: 0, y: 0, width: screenWidth, height: rowHeight)))
                expect(secondCellAttributes.frame).to(beCloseTo(CGRect(x: 0, y: rowHeight + vPadding, width: screenWidth / 2 - hPadding, height: rowHeight)))
                expect(thirdCellAttributes.frame).to(beCloseTo(CGRect(x: screenWidth / 2, y: rowHeight + vPadding, width: screenWidth / 2, height: rowHeight)))
                expect(fourthCellAttributes.frame).to(beCloseTo(CGRect(x: 0, y: 2 * (rowHeight + vPadding), width: (screenWidth - 2 * hPadding) / 3, height: rowHeight)))
                
                let secondX = (screenWidth - 2 * hPadding) / 3 + hPadding
                expect(fifthCellAttributes.frame).to(beCloseTo(CGRect(x: secondX, y: 2 * (rowHeight + vPadding), width: (screenWidth - 2 * hPadding) / 3, height: rowHeight)))
                
                let thirdX = ((screenWidth - 2 * hPadding) / 3) * 2 + 2 * hPadding
                expect(sixthCellAttributes.frame).to(beCloseTo(CGRect(x: thirdX, y: 2 * (rowHeight + vPadding), width: (screenWidth - 2 * hPadding) / 3, height: rowHeight)))
            }
            
            it("should have valid row height for custom visible rows count") {
                let items = ["Facebook", "Twitter", "Instagram", "Network", "Framework", "Test"]
                let layoutConfiguration = [0: 1, 1: 2, 2: 3]
                
                let px500FlowLayout = self.configure500PxFlowLayout(layoutConfiguration: layoutConfiguration, visibleRowsCount: 3, isCellsTransefered: true, items: items)
                let attributes = px500FlowLayout.cachedLayoutAttributes
                
                for item in attributes {
                    expect(item.frame.height).to(beCloseTo(px500FlowLayout.collectionView!.frame.height / CGFloat(3)))
                }
            }
            
            it("should have zero values for empty items array") {
                let px500FlowLayout = self.configure500PxFlowLayout(layoutConfiguration: Dictionary<Int, Int>(), isCellsTransefered: true, items: [String]())
                let attributes = px500FlowLayout.cachedLayoutAttributes
                
                expect(attributes.count).to(equal(0))
            }
        }
    }
    
    private func configure500PxFlowLayout(contentPadding: ItemsPadding = ItemsPadding(), layoutConfiguration: Dictionary<Int, Int> = Dictionary<Int, Int>(),  cellsPadding: ItemsPadding = ItemsPadding(), visibleRowsCount: Int = 5, isCellsTransefered: Bool = false, align: DynamicContentAlign = .left, items: [String]) -> Px500StyleFlowLayout {
        let flowDelegate = Px500FlowDelegateMock(items: items)
        let px500FlowLayout = Px500StyleFlowLayout()
        let fiveElementsDelegateMock = Px500FiveElementsDelegateMock()
        px500FlowLayout.delegate = isCellsTransefered ? fiveElementsDelegateMock : flowDelegate
        px500FlowLayout.layoutConfiguration = layoutConfiguration
        px500FlowLayout.visibleRowsCount = visibleRowsCount
        
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
