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
        
        describe("Check instagram style flow layout") {
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
        
        describe("Check instagram style flow layout with default grid mode") {
            it("should have every cell valid frame") {
                let instagramFlowLayout = self.configureInstagramStyleFlowLayout(items: items)
                let attributes = instagramFlowLayout.cachedLayoutAttributes
                
                let screenWidth = UIScreen.main.bounds.width / 3
                
                var rowCount: Int = 0

                for attr in attributes {
                    expect(attr.frame.size.width).to(beLessThanOrEqualTo(screenWidth))
                    expect(attr.frame.size.height).to(beLessThanOrEqualTo(screenWidth))
                    expect(attr.frame.origin.y).to(equal(CGFloat(rowCount) * screenWidth))
                    
                    if attr.indexPath.row % 3 == 0 {
                        expect(attr.frame.origin.x).to(equal(0))
                    } else if attr.indexPath.row % 3 == 1 {
                        expect(attr.frame.origin.x).to(equal(screenWidth))
                    } else if attr.indexPath.row % 3 == 2 {
                        expect(attr.frame.origin.x).to(equal(screenWidth * 2))
                        
                        rowCount += 1
                    }
                }
            }
            
            it("should have every cell valid frame with content padding") {
                let hPadding: CGFloat = 10
                let vPadding: CGFloat = 10
                let contentPadding = ItemsPadding(horizontal: hPadding, vertical: vPadding)
                let instagramFlowLayout = self.configureInstagramStyleFlowLayout(contentPadding: contentPadding, items: items)
                let attributes = instagramFlowLayout.cachedLayoutAttributes
                
                let screenWidth = (UIScreen.main.bounds.width - 2 * hPadding) / 3
                
                var rowCount: Int = 0
                
                for attr in attributes {
                    expect(attr.frame.size.width).to(beLessThanOrEqualTo(screenWidth))
                    expect(attr.frame.size.height).to(beLessThanOrEqualTo(screenWidth))
                    expect(attr.frame.origin.y).to(beCloseTo(CGFloat(rowCount) * screenWidth + vPadding))
                    
                    if attr.indexPath.row % 3 == 0 {
                        expect(attr.frame.origin.x).to(equal(hPadding))
                    } else if attr.indexPath.row % 3 == 1 {
                        expect(attr.frame.origin.x).to(equal(screenWidth + hPadding))
                    } else if attr.indexPath.row % 3 == 2 {
                        expect(attr.frame.origin.x).to(equal(screenWidth * 2 + hPadding))
                        
                        rowCount += 1
                    }
                }
            }
            
            it("should have every cell valid frame with cells padding") {
                let hPadding: CGFloat = 8
                let vPadding: CGFloat = 8
                let cellsPadding = ItemsPadding(horizontal: hPadding, vertical: vPadding)
                let instagramFlowLayout = self.configureInstagramStyleFlowLayout(cellsPadding: cellsPadding, items: items)
                let attributes = instagramFlowLayout.cachedLayoutAttributes
                
                let screenWidth = (UIScreen.main.bounds.width - 2 * hPadding) / 3
                
                var rowCount: Int = 0
                
                for attr in attributes {
                    expect(attr.frame.size.width).to(beLessThanOrEqualTo(screenWidth))
                    expect(attr.frame.size.height).to(beLessThanOrEqualTo(screenWidth))
                    expect(attr.frame.origin.y).to(beCloseTo(CGFloat(rowCount) * (screenWidth + vPadding)))
                    
                    if attr.indexPath.row % 3 == 0 {
                        expect(attr.frame.origin.x).to(equal(0))
                    } else if attr.indexPath.row % 3 == 1 {
                        expect(attr.frame.origin.x).to(equal(screenWidth + hPadding))
                    } else if attr.indexPath.row % 3 == 2 {
                        expect(attr.frame.origin.x).to(equal((screenWidth + hPadding) * 2))
                        
                        rowCount += 1
                    }
                }
            }
        }
    }
    
    private func configureInstagramStyleFlowLayout(contentPadding: ItemsPadding = ItemsPadding(), cellsPadding: ItemsPadding = ItemsPadding(), contentType: ContentCountType = .oneCell, gridType: GridType = .defaultGrid, items: [String]) -> InstagramStyleFlowLayout {
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
