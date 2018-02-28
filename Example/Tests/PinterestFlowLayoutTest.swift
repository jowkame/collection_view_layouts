//
//  PinterestFlowLayoutTest.swift
//  collection_flow_layout_Example
//
//  Created by jowkame on 2/28/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Quick
import Nimble
import collection_flow_layout

class PinterestFlowLayoutTest: QuickSpec {
    private let kScreenWidth: CGFloat = 414
    private let kScreenHeight: CGFloat = 736
    
    override func spec() {
        let items = ["Twitter", "Facebook", "Instagram", "A", "B", "Frameworks", "Developers", "Source code"]
        
        describe("Check tags flow layout") {
            it("tags flow layout fields validation") {
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
        
        describe("Check tags flow inner items") {
            it("tags flow layout cells frames") {
                let pinterestFlowLayout = self.configurePinterestFlowLayout(items: items)
                let attr = pinterestFlowLayout.cachedLayoutAttributes
                
                expect(attr[0].frame.origin.x).to(equal(0))
                expect(attr[0].frame.origin.y).to(equal(0))
                expect(attr[0].frame.width).to(equal(207))
                expect(attr[0].frame.height).to(equal(71))
                
                expect(attr[1].frame.origin.x).to(equal(207))
                expect(attr[1].frame.origin.y).to(equal(0))
                expect(attr[1].frame.width).to(equal(207))
                expect(attr[1].frame.height).to(equal(137))
                
                expect(attr[2].frame.origin.x).to(equal(0))
                expect(attr[2].frame.origin.y).to(equal(71))
                expect(attr[2].frame.width).to(equal(207))
                expect(attr[2].frame.height).to(equal(52))
                
                expect(attr[3].frame.origin.x).to(equal(0))
                expect(attr[3].frame.origin.y).to(equal(123))
                expect(attr[3].frame.width).to(equal(207))
                expect(attr[3].frame.height).to(equal(81))
                
                expect(attr[4].frame.origin.x).to(equal(207))
                expect(attr[4].frame.origin.y).to(equal(137))
                expect(attr[4].frame.width).to(equal(207))
                expect(attr[4].frame.height).to(equal(111))
                
                expect(attr[5].frame.origin.x).to(equal(0))
                expect(attr[5].frame.origin.y).to(equal(204))
                expect(attr[5].frame.width).to(equal(207))
                expect(attr[5].frame.height).to(equal(76))
                
                expect(attr[6].frame.origin.x).to(equal(207))
                expect(attr[6].frame.origin.y).to(equal(248))
                expect(attr[6].frame.width).to(equal(207))
                expect(attr[6].frame.height).to(equal(83))
                
                expect(attr[7].frame.origin.x).to(equal(0))
                expect(attr[7].frame.origin.y).to(equal(280))
                expect(attr[7].frame.width).to(equal(207))
                expect(attr[7].frame.height).to(equal(121))
            }
            
            it("tags flow layout cells frames with padding") {
                let contentPadding = ItemsPadding(horizontal: 10, vertical: 10)
                let cellPadding = ItemsPadding(horizontal: 8, vertical: 8)
                let pinterestFlowLayout = self.configurePinterestFlowLayout(contentPadding: contentPadding, cellsPadding: cellPadding, items: items)
                let attr = pinterestFlowLayout.cachedLayoutAttributes
                
                expect(attr[0].frame.origin.x).to(equal(10))
                expect(attr[0].frame.origin.y).to(equal(10))
                expect(attr[0].frame.width).to(equal(193))
                expect(attr[0].frame.height).to(equal(71))
                
                expect(attr[1].frame.origin.x).to(equal(211))
                expect(attr[1].frame.origin.y).to(equal(10))
                expect(attr[1].frame.width).to(equal(193))
                expect(attr[1].frame.height).to(equal(137))
                
                expect(attr[2].frame.origin.x).to(equal(10))
                expect(attr[2].frame.origin.y).to(equal(89))
                expect(attr[2].frame.width).to(equal(193))
                expect(attr[2].frame.height).to(equal(52))
                
                expect(attr[3].frame.origin.x).to(equal(10))
                expect(attr[3].frame.origin.y).to(equal(149))
                expect(attr[3].frame.width).to(equal(193))
                expect(attr[3].frame.height).to(equal(81))
                
                expect(attr[4].frame.origin.x).to(equal(211))
                expect(attr[4].frame.origin.y).to(equal(155))
                expect(attr[4].frame.width).to(equal(193))
                expect(attr[4].frame.height).to(equal(111))
                
                expect(attr[5].frame.origin.x).to(equal(10))
                expect(attr[5].frame.origin.y).to(equal(238))
                expect(attr[5].frame.width).to(equal(193))
                expect(attr[5].frame.height).to(equal(76))
                
                expect(attr[6].frame.origin.x).to(equal(211))
                expect(attr[6].frame.origin.y).to(equal(274))
                expect(attr[6].frame.width).to(equal(193))
                expect(attr[6].frame.height).to(equal(83))
                
                expect(attr[7].frame.origin.x).to(equal(10))
                expect(attr[7].frame.origin.y).to(equal(322))
                expect(attr[7].frame.width).to(equal(193))
                expect(attr[7].frame.height).to(equal(121))
            }
        }
    }
    
    private func configurePinterestFlowLayout(contentPadding: ItemsPadding = ItemsPadding(), cellsPadding: ItemsPadding = ItemsPadding(), items: [String]) -> PinterestStyleFlowLayout {
        let flowDelegate = PinterestFlowDelegate()
        let pinterestFlowLayout = PinterestStyleFlowLayout()
        pinterestFlowLayout.delegate = flowDelegate
        pinterestFlowLayout.contentPadding = contentPadding
        pinterestFlowLayout.cellsPadding = cellsPadding
        
        let dataSource = ContentDataSource()
        dataSource.items = items
        
        let collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight), collectionViewLayout: pinterestFlowLayout)
        collectionView.dataSource = dataSource
        
        pinterestFlowLayout.calculateCollectionViewCellsFrames()
        
        return pinterestFlowLayout
    }
}
