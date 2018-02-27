//
//  ViewController.swift
//  CollectionDemoApp
//
//  Created by sergey on 2/22/18.
//  Copyright © 2018 rubygarage. All rights reserved.
//

import UIKit
import collection_flow_layout

enum FLowLayoutType: Int {
    case tags
    case pinterest
}

class ViewController: UIViewController, ContentDynamicLayoutDelegate {
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var pickerView: UIPickerView!
    
    private var pickerViewTitlesProvider: PickerDelegate?
    private var pickerViewDataSource: PickerDataSource?
    private var contentFlowLayout: ContentDynamicLayout?
    private var contentDataSource: ContentDataSource?
    private var dataItems = [String]()
    private var cellsSizes = [CGSize]()
    private var flowItemsTitles = ["Tags Layout", "Pinterest Layout"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    private func setup() {
        setupDataPickerView()
        setupDataItems()
        setupCollectionView()
    }
    
    private func setupDataPickerView() {
        pickerViewTitlesProvider = PickerDelegate()
        pickerViewDataSource = PickerDataSource()

        pickerViewTitlesProvider?.items = flowItemsTitles
        pickerViewTitlesProvider?.rowSelectHandler = { [weak self] (row) in
            self?.showLayout(type: FLowLayoutType(rawValue: row)!)
        }

        pickerViewDataSource?.items = flowItemsTitles

        pickerView.delegate = pickerViewTitlesProvider
        pickerView.dataSource = pickerViewDataSource

        pickerView.reloadAllComponents()
    }

    private func setupDataItems() {
        dataItems = ContentProvider.provideTextData()
    }

    private func setupCollectionView() {
        contentDataSource = ContentDataSource()
        contentDataSource?.items = dataItems
        collectionView.dataSource = contentDataSource

        showLayout(type: .tags)
    }

    private func showLayout(type: FLowLayoutType) {
        if type == .tags {
            contentFlowLayout = TagsStyleFlowLayout()
        } else if type == .pinterest {
            contentFlowLayout = PinterestStyleFlowLayout()
        }

        contentFlowLayout?.delegate = self
        contentFlowLayout?.contentPadding = ItemsPadding(horizontal: 10, vertical: 10)
        contentFlowLayout?.cellsPadding = ItemsPadding(horizontal: 8, vertical: 8)

        collectionView.collectionViewLayout = contentFlowLayout!
        collectionView.setContentOffset(CGPoint.zero, animated: false)

        cellsSizes = CellSizeProvider.provideSizes(items: dataItems, flowType: type)

        collectionView.reloadData()
    }

    func cellSize(indexPath: IndexPath) -> CGSize {
        return cellsSizes[indexPath.row]
    }
}
