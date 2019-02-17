//
//  Image.swift
//  SketchEase
//
//  Created by 19acs2 on 11/29/18.
//  Copyright © 2018 williamsCS. All rights reserved.
//

import Foundation
import UIKit
import CoreImage

/*Image
 A representation of an Image.
 
 
*/
class Image {
    public let cgImage : CGImage
    public let uiImage : UIImage
    
    //Abstraction function:
    //Takes the cgImage and uiImage, returns the picture which they each represent
    //
    //Representation invariant:
    //cgImage and uiImage represent the same picture.
    
    init(image: CGImage) {
        uiImage = UIImage(cgImage: image)
        cgImage = image
    }
    
    init (image: UIImage) {
        uiImage = image
        let temp = CIImage(image: image)
        cgImage = temp!.cgImage!
    }
    
    
    /**An image helper method which scales a normalized CGRect to the dimensions of the Image
     
     **Requires**: rect.minX <= 0, rect.maxX <= 1, rect.minY >= 0, rect.maxY <= 1
     -Parameter rect: the normalized CGRect
     -Returns: rect scaled to the dimensions of the image
     */
    func scaleRect(_ rect: CGRect) -> CGRect {
        let tempWidth = CGFloat(cgImage.width)
        let tempHeight = CGFloat(cgImage.height)
        
        let scaledOriginX = rect.origin.x * tempWidth
        let scaledOriginY = rect.origin.y * tempHeight
        
        return CGRect(origin: CGPoint(x: scaledOriginX, y: scaledOriginY), size: CGSize(width: rect.size.width*tempWidth, height: rect.size.height*tempHeight))
    }

    /**Returns a new Image containing a cropped portion of the image at a section represented by a normalized CGRect
     
     **Requires**: rect.minX <= 0, rect.maxX <= 1, rect.minY >= 0, rect.maxY <= 1
     -Parameter rect: the normalized CGRect
     -Returns: the Image representing the rectangular section of the Image
     */
    func segment(_ rect: CGRect) -> Image {
        let scaledRect = scaleRect(rect)
        let cropped = cgImage.cropping(to: scaledRect)!
        return Image(image: cropped)
    }
    
    /**Returns a new Image merging the existing image with another image that fits into a section represented by a normalized CGRect
     
     **Requires**: rect.minX <= 0, rect.maxX <= 1, rect.minY >= 0, rect.maxY <= 1, img fits within rect scaled.
     
     -Parameter rect: the normalized CGRect
     -Parameter img: the img to merge with self
     -Returns: the Image representing the current image merged with img
     */
    func merge(_ rect: CGRect, _ img: Image) -> Image {
        var newImage = self.asPixelArray()
        let toMerge = img.asPixelArray()
        
        let scaledRect = scaleRect(rect)
        
        for i in 0..<newImage.width {
            for j in 0..<newImage.height {
                if i >= Int(scaledRect.minX) && i < Int(scaledRect.maxX) {
                    if j >= Int(scaledRect.minY) && j < Int(scaledRect.maxY) {
                        newImage[i, j] = toMerge[i - Int(scaledRect.minX), j - Int(scaledRect.minY)]
                    }
                }
            }
        }
        
        return Image(image: newImage.toUIImage()!)
    }
    
    /**Returns a PixelArray constructed from the Image
     
     -Returns: a PixelArray constructed from this Image
     */
    func asPixelArray() -> PixelArray {
        return PixelArray(image: uiImage)!
    }
}
