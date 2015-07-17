//
//  GradientView.swift
//  StoreSearch
//
//  Created by Anthony Camara on 17/07/2015.
//  Copyright (c) 2015 Anthony Camara. All rights reserved.
//

import UIKit

class GradientView: UIView {

// MARK: - Init Class
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.clearColor()
        autoresizingMask = .FlexibleWidth | .FlexibleHeight
    }

    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        backgroundColor = UIColor.clearColor()
        autoresizingMask = .FlexibleWidth | .FlexibleHeight
    }
    
    
// MARK: - Draw View
    
    override func drawRect(rect: CGRect) {
        
        let components: [CGFloat] = [ 0, 0, 0, 0.3, 0, 0, 0, 0.7 ]
        let locations: [CGFloat] = [ 0, 1 ]
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let gradient = CGGradientCreateWithColorComponents(colorSpace, components, locations, 2)
        
        let x = CGRectGetMaxX(bounds)
        let y = CGRectGetMaxY(bounds)
        let point = CGPoint(x: x, y: y)
        let radius = max(x, y)
        
        let context = UIGraphicsGetCurrentContext()
        CGContextDrawRadialGradient(context, gradient, point, 0, point, radius, CGGradientDrawingOptions(kCGGradientDrawsAfterEndLocation))
    }
    
}
