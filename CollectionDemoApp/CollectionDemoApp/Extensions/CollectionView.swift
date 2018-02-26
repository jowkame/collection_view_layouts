//
//  CollectionView.swift
//  CollectionDemoApp
//
//  Created by sergey on 2/23/18.
//  Copyright © 2018 rubygarage. All rights reserved.
//

import UIKit

extension UICollectionView {
    func addGradient() {
        let gradient = CAGradientLayer()
        gradient.frame = bounds
        
        gradient.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
        gradient.locations = [0.0, 0.5]
        
        superview?.layer.mask = gradient
    }
}
