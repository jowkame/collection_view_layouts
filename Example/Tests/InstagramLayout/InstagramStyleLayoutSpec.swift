//
//  InstagramLayoutSpec.swift
//  collection_flow_layout_Example
//
//  Created by sergey on 3/27/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Quick
import Nimble
import Fakery
@testable import collection_flow_layout

class InstagramStyleLayoutSpec: QuickSpec {
    enum ContentCountType {
        case oneCell
        case twoCells
        case threeCells
    }

    private let kInstagramFlowLayoutMaxItems: UInt32 = 40
    private let kInstagramFlowLayoutMinItems: UInt32 = 20
    
    override func spec() {
        let itemsCount = Int(arc4random_uniform(kInstagramFlowLayoutMaxItems) + kInstagramFlowLayoutMinItems)
        let items = Faker.init().lorem.words(amount: itemsCount).components(separatedBy: .whitespaces)
        
        describe("Check 500px style flow layout") {
            it("should have default values") {
                let instagramStyleFlowLayout = InstagramStyleFlowLayout()
                
                expect(instagramStyleFlowLayout.contentAlign).to(beAKindOf(DynamicContentAlign.self))
                expect(instagramStyleFlowLayout.contentAlign).to(equal(DynamicContentAlign.left))
                expect(instagramStyleFlowLayout.contentAlign).notTo(equal(DynamicContentAlign.right))
                
                expect(instagramStyleFlowLayout.cellsPadding).to(beAKindOf(ItemsPadding.self))
                expect(instagramStyleFlowLayout.cellsPadding.horizontal).to(equal(0))
                expect(instagramStyleFlowLayout.cellsPadding.vertical).to(equal(0))
                
                expect(instagramStyleFlowLayout.contentPadding).to(beAKindOf(ItemsPadding.self))
                expect(instagramStyleFlowLayout.contentPadding.horizontal).to(equal(0))
                expect(instagramStyleFlowLayout.contentPadding.vertical).to(equal(0))
                
                expect(instagramStyleFlowLayout.contentSize).to(beAKindOf(CGSize.self))
                
                instagramStyleFlowLayout.calculateCollectionViewCellsFrames()
                
                expect(instagramStyleFlowLayout.cachedLayoutAttributes.count).to(equal(0))
                
                expect(instagramStyleFlowLayout.collectionView).to(beNil())
                expect(instagramStyleFlowLayout.delegate).to(beNil())
            }
        }
    }
    
    private func configureInstagramStyleFlowLayout(contentPadding: ItemsPadding = ItemsPadding(), cellsPadding: ItemsPadding = ItemsPadding(), columnsCount: Int = 2, contentType: ContentCountType = .oneCell, gridType: GridType = .defaultGrid, items: [String]) -> InstagramStyleFlowLayout {
        var flowDelegate: ContentDynamicLayoutDelegate! = nil
        
        if contentType == .oneCell {
            flowDelegate = InstagramStyleSingleItemDelegateMock()
        }
        
        let instagramStyleFlowLayout = InstagramStyleFlowLayout()
        instagramStyleFlowLayout.delegate = flowDelegate
        instagramStyleFlowLayout.contentPadding = contentPadding
        instagramStyleFlowLayout.cellsPadding = cellsPadding
        instagramStyleFlowLayout.gridType = gridType
        
        let dataSource = ContentDataSource()
        dataSource.items = items
        
        let collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height), collectionViewLayout: instagramStyleFlowLayout)
        collectionView.dataSource = dataSource
        
        instagramStyleFlowLayout.calculateCollectionViewCellsFrames()
        
        return instagramStyleFlowLayout
    }
}
