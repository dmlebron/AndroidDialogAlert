//
//  UITextField+Default.swift
//  AndroidDialogAlert
//
//  Created by Dava on 5/19/17.
//  Copyright © 2017 Davaur. All rights reserved.
//

import UIKit

extension UITextField {
    
    private var bottomLayerHeight: CGFloat {
        return 1.0
    }
    
    private var layerColor: UIColor {
        return UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
    }
    
    /// Adds bottom layer of height equals 1.
    func addBottomLine() {
        let layer = CALayer()
        
        layer.frame = CGRect(x: 0, y: frame.height, width: frame.width, height: bottomLayerHeight)
        layer.backgroundColor = layerColor.cgColor
        self.layer.addSublayer(layer)
    }
    
}
