//
//  TagsFlowLayoutTest.swift
//  collection_flow_layout_Example
//
//  Created by sergey on 2/28/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Quick
import Nimble
import Fakery
@testable import collection_flow_layout

class TagsStyleFlowLayoutSpec: QuickSpec {
    private let kTagsStyleFlowLayoutMaxItems: UInt32 = 20
    private let kTagsStyleFlowLayoutMinItems: UInt32 = 10

    override func spec() {
        let itemsCount = Int(arc4random_uniform(kTagsStyleFlowLayoutMaxItems) + kTagsStyleFlowLayoutMinItems)
        let items = Faker.init().lorem.words(amount: itemsCount).components(separatedBy: .whitespaces)
        
        describe("Check tags flow layout") {
            it("should have default values") {
                let tagsFlowLayout = TagsStyleFlowLayout()
                
                expect(tagsFlowLayout.contentAlign).to(beAKindOf(DynamicContentAlign.self))
                expect(tagsFlowLayout.contentAlign).to(equal(DynamicContentAlign.left))
                
                expect(tagsFlowLayout.cellsPadding).to(beAKindOf(ItemsPadding.self))
                expect(tagsFlowLayout.cellsPadding.horizontal).to(equal(0))
                expect(tagsFlowLayout.cellsPadding.vertical).to(equal(0))
                
                expect(tagsFlowLayout.contentPadding).to(beAKindOf(ItemsPadding.self))
                expect(tagsFlowLayout.contentPadding.horizontal).to(equal(0))
                expect(tagsFlowLayout.contentPadding.vertical).to(equal(0))
                
                expect(tagsFlowLayout.contentSize).to(beAKindOf(CGSize.self))
                
                tagsFlowLayout.calculateCollectionViewCellsFrames()
                
                expect(tagsFlowLayout.cachedLayoutAttributes.count).to(equal(0))
                
                expect(tagsFlowLayout.collectionView).to(beNil())
                expect(tagsFlowLayout.delegate).to(beNil())
            }
        }
        
        describe("Check tags flow inner items") {
            let tagsFlowLayout = self.configureTagsFlowLayout(items: items)
            let attributes = tagsFlowLayout.cachedLayoutAttributes
            
            it("test cells equal height") {
                let firstCellAttr = attributes.first!
                
                expect(firstCellAttr.frame.width).notTo(equal(0))
                expect(firstCellAttr.frame.height).notTo(equal(0))
                
                for attr in attributes {
                    expect(attr.frame.size.height).to(equal(firstCellAttr.frame.height))
                    expect(attr.frame.size.width).to(beLessThanOrEqualTo(UIScreen.main.bounds.width))
                }
            }
            
            it ("test base paddings") {
                expect(tagsFlowLayout.cellsPadding.horizontal).to(equal(0))
                expect(tagsFlowLayout.cellsPadding.vertical).to(equal(0))
                expect(tagsFlowLayout.contentPadding.horizontal).to(equal(0))
                expect(tagsFlowLayout.contentPadding.vertical).to(equal(0))
            }

            it("test cells left align and items transfer") {
                expect(tagsFlowLayout.contentAlign).to(equal(DynamicContentAlign.left))
                
                var widthSum: CGFloat = 0
                var heightSum: CGFloat = 0
                
                for item in attributes {
                    if widthSum + item.frame.size.width > UIScreen.main.bounds.width {
                        heightSum += item.frame.size.height
                        widthSum = 0

                        expect(item.frame.origin.x).to(equal(0))
                        expect(item.frame.origin.y).to(equal(heightSum))
                    }
                    widthSum += item.frame.size.width
                }
            }
        }
        
        describe("Check tags flow inner items with custom settings") {
            it("test cells right align and items transfer") {
                let tagsFlowLayout = self.configureTagsFlowLayout(align: .right, items: items)
                let attributes = tagsFlowLayout.cachedLayoutAttributes
                
                expect(tagsFlowLayout.contentAlign).to(equal(DynamicContentAlign.right))
                
                var widthSum: CGFloat = UIScreen.main.bounds.width
                var heightSum: CGFloat = 0

                for item in attributes {
                    if widthSum - item.frame.size.width < 0 {
                        heightSum += item.frame.size.height
                        widthSum = UIScreen.main.bounds.width
                        
                        expect(item.frame.origin.x).to(equal(UIScreen.main.bounds.width - item.frame.size.width))
                        expect(item.frame.origin.y).to(equal(heightSum))
                    }
                    widthSum -= item.frame.size.width
                }
            }
            
            it("test layout content padding") {
                let hPadding: CGFloat = 10
                let vPadding: CGFloat = 10
                
                let tagsFlowLayout = self.configureTagsFlowLayout(contentPadding: ItemsPadding(horizontal: hPadding, vertical: vPadding), items: items)
                let attributes = tagsFlowLayout.cachedLayoutAttributes
                
                var widthSum: CGFloat = hPadding
                var rowCount: Int = 0
                
                for item in attributes {
                    if widthSum + item.frame.size.width > (UIScreen.main.bounds.width) {
                        widthSum = hPadding
                        rowCount += 1
                        
                        expect(item.frame.origin.x).to(equal(hPadding))
                    }
                    
                    if rowCount == 0 {
                        expect(item.frame.origin.y).to(equal(vPadding))
                    }
                    
                    widthSum += item.frame.size.width
                }
            }
            
            it("test layout cells padding") {
                let hPadding: CGFloat = 10
                let vPadding: CGFloat = 10
                
                let tagsFlowLayout = self.configureTagsFlowLayout(cellsPadding: ItemsPadding(horizontal: hPadding, vertical: vPadding), items: items)
                let attributes = tagsFlowLayout.cachedLayoutAttributes
                
                var rowCount: Int = 0
                var previousXOffset: CGFloat = 0
                var previousYOffset: CGFloat = 0
                var previousFrame: CGRect = .zero
                
                for item in attributes {
                    if previousXOffset + item.frame.size.width + hPadding > (UIScreen.main.bounds.width - hPadding) {
                        previousXOffset = 0
                        rowCount += 1
                        previousYOffset = previousFrame.origin.y + previousFrame.size.height
                    }
                    
                    if previousXOffset > 0 {
                        expect(item.frame.origin.x - previousXOffset).to(equal(hPadding))
                    }
                    
                    if rowCount > 0 {
                        expect(item.frame.origin.y - previousYOffset).to(equal(hPadding))
                    }
                    
                    previousFrame = item.frame
                    previousXOffset = item.frame.origin.x + item.frame.size.width
                }
            }
        }
    }
    
    private func configureTagsFlowLayout(contentPadding: ItemsPadding = ItemsPadding(), cellsPadding: ItemsPadding = ItemsPadding(), align: DynamicContentAlign = .left, items: [String]) -> TagsStyleFlowLayout {
        let flowDelegate = TagsFlowDelegateMock(items: items)
        let tagsFlowLayout = TagsStyleFlowLayout()
        tagsFlowLayout.delegate = flowDelegate
        
        tagsFlowLayout.contentPadding = contentPadding
        tagsFlowLayout.cellsPadding = cellsPadding
        tagsFlowLayout.contentAlign = align
        
        let dataSource = ContentDataSource()
        dataSource.items = items
        
        let collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height), collectionViewLayout: tagsFlowLayout)
        collectionView.dataSource = dataSource
        
        tagsFlowLayout.calculateCollectionViewCellsFrames()
        
        expect(tagsFlowLayout.collectionView).notTo(beNil())
        
        _ = flowDelegate.cellSize(indexPath: IndexPath(row: 0, section: 0))
        expect(flowDelegate.isCellSizeWasCalled).to(beTrue())
        
        expect(tagsFlowLayout.delegate).notTo(beNil())
        expect(tagsFlowLayout.delegate).to(beAKindOf(ContentDynamicLayoutDelegate.self))
        
        return tagsFlowLayout
    }
}
