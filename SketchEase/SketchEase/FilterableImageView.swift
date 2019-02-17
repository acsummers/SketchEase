//
//  FilterableImageView.swift
//  SketchEase
//
//  Created by 19acs2 on 11/29/18.
//  Copyright © 2018 williamsCS. All rights reserved.
//

import Foundation
import UIKit

//An ImageView containing a FilterableImage
//Able to be extended to add an overlay to the displayed image
class FilterableImageView: UIImageView {
    public var overlay : UIBezierPath? {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    override public func draw(_ rect: CGRect) {
        super.draw(rect)
    }
}
