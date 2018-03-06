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
    private let kTagsStyleFlowLayoutMaxItems: UInt32 = 100
    private let kTagsStyleFlowLayoutMinItems: UInt32 = 10

    override func spec() {
        let itemsCount = Int(arc4random_uniform(kTagsStyleFlowLayoutMaxItems) + kTagsStyleFlowLayoutMinItems)
        let items = Faker.init().lorem.words(amount: itemsCount).components(separatedBy: .whitespaces)
        
        describe("Check tags flow layout") {
            it("tags flow layout fields validation") {
                let tagsFlowLayout = self.configureTagsFlowLayout(items: items)
                
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
        
        describe("Check tags flow inner items") {
            it("tags flow layout cells frames") {
                let tagsFlowLayout = self.configureTagsFlowLayout(items: items)
                let attributes = tagsFlowLayout.cachedLayoutAttributes
                
                let firstCellAttr = attributes.first!
                
                expect(firstCellAttr.frame.width).notTo(equal(0))
                expect(firstCellAttr.frame.height).notTo(equal(0))
                
                for attr in attributes {
                    expect(attr.frame.size.height).to(equal(firstCellAttr.frame.height))
                    expect(attr.frame.size.width).to(beLessThanOrEqualTo(UIScreen.main.bounds.width))
                }
                
                let yValues = attributes.map({$0.frame.origin.y})
                let yOffsetsFrequency = self.valuesFrequency(values: yValues)
                
                for info in yOffsetsFrequency {
                    expect(info.frequency).to(beGreaterThanOrEqualTo(1))
                }
                
                let xValues = attributes.map({$0.frame.origin.x})
                let xOffsetsFrequency = self.valuesFrequency(values: xValues)
                
                for info in xOffsetsFrequency {
                    expect(info.frequency).to(beGreaterThanOrEqualTo(1))
                }
                
                let maxFrequency = xOffsetsFrequency.map({$0.frequency}).max() ?? 0
                let offsetWithMaxFrequency = xOffsetsFrequency.filter({return $0.frequency == maxFrequency}).first!
                
                expect(offsetWithMaxFrequency.offset).to(equal(0))
            }
        }
        
        describe("Check tags flow inner items") {
            it("tags flow layout cells frames with custom settings") {
                let kContentPadding: CGFloat = 10
                let kCellPadding: CGFloat = 8
                
                let tagsFlowLayout = self.configureTagsFlowLayout(contentPadding: ItemsPadding(horizontal: kContentPadding, vertical: kContentPadding), cellsPadding: ItemsPadding(horizontal: kCellPadding, vertical: kCellPadding), align: .right, items: items)
                let attributes = tagsFlowLayout.cachedLayoutAttributes
                
                let firstCellAttr = attributes.first!
                
                expect(firstCellAttr.frame.width).notTo(equal(0))
                expect(firstCellAttr.frame.height).notTo(equal(0))
                
                for attr in attributes {
                    expect(attr.frame.size.height).to(equal(firstCellAttr.frame.height))
                    expect(attr.frame.size.width).to(beLessThanOrEqualTo(UIScreen.main.bounds.width - 2 * kContentPadding))
                }
                
                let yValues = attributes.map({$0.frame.origin.y})
                let yOffsetsFrequency = self.valuesFrequency(values: yValues)
                
                for info in yOffsetsFrequency {
                    expect(info.frequency).to(beGreaterThanOrEqualTo(1))
                }
                
                let xValues = attributes.map({$0.frame.origin.x + $0.frame.width})
                let trailingOffsetsFrequency = self.valuesFrequency(values: xValues)
                
                for info in trailingOffsetsFrequency {
                    expect(info.frequency).to(beGreaterThanOrEqualTo(1))
                }
                
                let maxFrequency = trailingOffsetsFrequency.map({$0.frequency}).max() ?? 0
                let offsetWithMaxFrequency = trailingOffsetsFrequency.filter({return $0.frequency == maxFrequency}).first!
                
                expect(offsetWithMaxFrequency.offset).to(equal(UIScreen.main.bounds.width - CGFloat(kContentPadding)))
               
                var previousCellFrame: CGRect = .zero
                
                for attr in attributes {
                    if previousCellFrame != .zero && previousCellFrame.origin.y == attr.frame.origin.y {
                        expect(previousCellFrame.origin.x - (attr.frame.origin.x + attr.frame.size.width)).to(equal(kCellPadding))
                    }
                    previousCellFrame = attr.frame
                }                
            }
        }
    }
    
    private func valuesFrequency(values: [CGFloat]) -> [(offset: CGFloat, frequency: Int)] {
        let countedSet = NSCountedSet(array: values)
        let countedOffsetsData = countedSet.objectEnumerator().map { (object: Any) -> (offset: CGFloat, frequency: Int) in
            return (offset: object as! CGFloat, frequency: countedSet.count(for: object))
        }
        
        return countedOffsetsData
    }
    
    private func configureTagsFlowLayout(contentPadding: ItemsPadding = ItemsPadding(), cellsPadding: ItemsPadding = ItemsPadding(), align: DynamicContentAlign = .left, items: [String]) -> TagsStyleFlowLayout {
        let flowDelegate = TagsFlowDelegate(items: items)
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
        
        return tagsFlowLayout
    }
}
