//
//  FilterableImage.swift
//  SketchEase
//
//  Created by Alexander Summers on 12/13/18.
//  Copyright © 2018 williamsCS. All rights reserved.
//

import Foundation
import UIKit

/*FilterableImage
 
A representation of an Image which can be filtered. Certain areas of the image may each have a filter applied to them.
 
 **Specification Properties**:
    - original image - the image without the filters applied
    - filters - functions that modify an area of the image
    - areas - portions of the image that each filter is applied to
 
 **Derived Specification Properties**:
    - display image - the image with each filter applied to an image
*/

class FilterableImage {
    private var original: Image
    private var display: Image
    
    /**A visual representation of the original image*/
    public var originalImage: UIImage {
        get {
            return original.uiImage
        }
    }
    
    /**The visual representation of the original image with all of the current filters applied to their respective areas*/
    public var displayImage: UIImage {
        get {
            return display.uiImage
        }
    }
    
    /**The rectangular areas of each filter*/
    public private(set) var boundingBoxes: [CGRect] = [] {
        didSet {
            appliedFilters = boundingBoxes.map({_ in PassThroughFilter()}) as [Filter]
            checkRep()
        }
    }
    
    /**The filters applied to the image*/
    public private(set) var appliedFilters: [Filter] = [] {
        didSet {
            applyFilters()
            checkRep()
        }
    }
    
    //Abstraction function:
    //The originalImage, appliedFilters, boundingBoxes, and displayImage are mapped to the original image, filters, areas, and display image in the specification properties respectively.
    
    //Representation invariants:
    //each boundingBox in boundingBoxes always corresponds with a filter in appliedFilters
    //the displayImage always displays the filters applied to the original image
    
    /**
     Initializes the FilterableImage from a UIImage
     
     - Parameter image: the UIImage to initialize from
    */
    public init(image: UIImage) {
        original = Image(image: image)
        display = Image(image: image)
        checkRep()
    }
    
    /**Detects the areas of faces in the original image and sets the boundingBoxes equal to these areas. Note that this overrides any current filters and boundingBoxes stored.
     
     **Modifies**: boundingBoxes, appliedFilters
     
     **Effects**: sets boundingBoxes to the areas of faces detected, setting appliedFilters to corresponding filters that return their original image.
     
     */
    public func detectFaces() {
        let detector = FaceDetector()
        let detectedRects = detector.detect(image: original)
        boundingBoxes = detectedRects
    }
    
    /**Applies the appliedFilters to the areas of the image specified by boundingBoxes.
     
     **Modifies**: displayImage
     
     **Effects**: sets the displayImage to the originalImage with the appliedFilters applied to the areas specified by boundingBoxes
     */
    public func applyFilters() {
        var image = original
        for f in 0..<boundingBoxes.count {
            let rect = boundingBoxes[f]
            let filter = appliedFilters[f]
            let faceBox = original.segment(rect)
            let filteredFace = filter.filter(faceBox)
            image = image.merge(rect, filteredFace)
        }
        display = image
    }
    
    /**Sets each filter in appliedFilters to a given filter.
     
     **Modifies**: appliedFilters
     
     **Effects**: sets each filter in appliedFilters equal to the given filter.
     
     - Parameter filter: the filter to set all appliedFilters to.
     */
    public func setFilter(filter: Filter) {
        appliedFilters = appliedFilters.map({_ in filter}) as [Filter]
    }
    
    //Asserts that the representation invariant remains true
    private func checkRep() {
        assert(boundingBoxes.count == appliedFilters.count)
    }
    
    
    
    
    
    
}
