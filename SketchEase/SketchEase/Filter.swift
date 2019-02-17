//
//  Filter.swift
//  SketchEase
//
//  Created by Alexander Summers on 12/4/18.
//  Copyright © 2018 williamsCS. All rights reserved.
//

import Foundation

/*
 A protocol encapsulating the necessary properties of a Filter, which transforms an Image and returns a new Image.
 */
protocol Filter {
    /**
     Returns a new image filtered in some way
     
     - Parameter: an image to be filtered
     - Returns: the image filtered
     */
    func filter(_ : Image) -> Image
}
