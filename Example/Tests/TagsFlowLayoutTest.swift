//
//  TagsFlowLayoutTest.swift
//  collection_flow_layout_Example
//
//  Created by sergey on 2/28/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Quick
import Nimble
import collection_flow_layout

class TagsFlowLayoutTest: QuickSpec {
    private let kScreenWidth: CGFloat = 414
    private let kScreenHeight: CGFloat = 736
    
    override func spec() {
        let items = ["Twitter", "Facebook", "Instagram", "A", "B", "Frameworks", "Developers", "Source code"]
        let tagsFlowLayout = configureTagsFlowLayout(items: items)
        
        describe("Check tags flow layout") {
            it("tags flow layout fields validation") {
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
                let attr = tagsFlowLayout.cachedLayoutAttributes
                
                expect(attr[0].frame.origin.x).to(equal(0))
                expect(attr[0].frame.origin.y).to(equal(0))
                expect(attr[0].frame.width).to(equal(67.7265625))
                expect(attr[0].frame.height).to(equal(35.287109375))

                expect(attr[1].frame.origin.x).to(equal(67.7265625))
                expect(attr[1].frame.origin.y).to(equal(0))
                expect(attr[1].frame.width).to(equal(89.3916015625))
                expect(attr[1].frame.height).to(equal(35.287109375))

                expect(attr[2].frame.origin.x).to(equal(157.1181640625))
                expect(attr[2].frame.origin.y).to(equal(0))
                expect(attr[2].frame.width).to(equal(91.333984375))
                expect(attr[2].frame.height).to(equal(35.287109375))

                expect(attr[3].frame.origin.x).to(equal(248.4521484375))
                expect(attr[3].frame.origin.y).to(equal(0))
                expect(attr[3].frame.width).to(equal(26.06494140625))
                expect(attr[3].frame.height).to(equal(35.287109375))

                expect(attr[4].frame.origin.x).to(equal(274.51708984375))
                expect(attr[4].frame.origin.y).to(equal(0))
                expect(attr[4].frame.width).to(equal(25.78271484375))
                expect(attr[4].frame.height).to(equal(35.287109375))

                expect(attr[5].frame.origin.x).to(equal(300.2998046875))
                expect(attr[5].frame.origin.y).to(equal(0))
                expect(attr[5].frame.width).to(equal(108.333984375))
                expect(attr[5].frame.height).to(equal(35.287109375))

                expect(attr[6].frame.origin.x).to(equal(0))
                expect(attr[6].frame.origin.y).to(equal(35.287109375))
                expect(attr[6].frame.width).to(equal(101.18701171875))
                expect(attr[6].frame.height).to(equal(35.287109375))

                expect(attr[7].frame.origin.x).to(equal(101.18701171875))
                expect(attr[7].frame.origin.y).to(equal(35.287109375))
                expect(attr[7].frame.width).to(equal(111.4716796875))
                expect(attr[7].frame.height).to(equal(35.287109375))
            }
        }
    }
    
    private func configureTagsFlowLayout(contentPadding: ItemsPadding = ItemsPadding(), cellsPadding: ItemsPadding = ItemsPadding(), items: [String]) -> TagsStyleFlowLayout {
        let flowDelegate = TagsFlowDelegate(items: items)
        let tagsFlowLayout = TagsStyleFlowLayout()
        tagsFlowLayout.delegate = flowDelegate
        tagsFlowLayout.contentPadding = contentPadding
        tagsFlowLayout.cellsPadding = cellsPadding
        
        let dataSource = ContentDataSource()
        dataSource.items = items
        
        let collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight), collectionViewLayout: tagsFlowLayout)
        collectionView.dataSource = dataSource
        
        tagsFlowLayout.calculateCollectionViewCellsFrames()
        
        return tagsFlowLayout
    }
}
