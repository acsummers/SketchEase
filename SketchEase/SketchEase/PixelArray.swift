//
//  PixelArray.swift
//  FunhouseMirrors
//
//  Created by freund on 9/8/17.
//  Copyright © 2017 Stephen Freund. All rights reserved.
//

import Foundation
import UIKit

struct Pixel {
  let red   : UInt8
  let green : UInt8
  let blue  : UInt8
  let alpha : UInt8
  
  static let black = Pixel(red: 0,green: 0,blue: 0,alpha: 0)
}

class PixelArray {
  var pixels: [Pixel]
  let width : Int
  let height: Int
  
  var bounds : CGSize {
    return CGSize(width: width, height: height)
  }
  
  subscript (x: Int, y: Int) -> Pixel {
    get {
      assert(0 <= x && x < width)
      assert(0 <= y && y < height)
      return pixels[x + y * width]
    }
    set {
      assert(0 <= x && x < width)
      assert(0 <= y && y < height)
      pixels[x + y * width] = newValue
    }
  }
  
  private static let unitBox = CGRect(x: -1, y: -1, width: 2, height: 2)
  
  subscript (pt: CGPoint) -> Pixel {
    get  {
      if PixelArray.unitBox.contains(pt) {
        let arrayX = Int(((Double(pt.x) + 1.0) / 2.0) * Double(width))
        let arrayY = Int(((Double(pt.y) + 1.0) / 2.0) * Double(height))
        return self[arrayX,arrayY]
      } else {
        return Pixel.black
      }
    }
    set  {
      assert(PixelArray.unitBox.contains(pt))
      let arrayX = Int(((Double(pt.x) + 1.0) / 2.0) * Double(width))
      let arrayY = Int(((Double(pt.y) + 1.0) / 2.0) * Double(height))
      self[arrayX,arrayY] = newValue
    }
  }
  
  
  
  init(bounds: CGSize) {
    width = Int(bounds.width)
    height = Int(bounds.height)
    let dataSize = width * height
    pixels = [Pixel](repeating: Pixel.black, count: dataSize)
  }
  
  convenience init?(image: UIImage) {
    self.init(bounds: image.size)
    let context = CGContext(data: &pixels,
                            width: width,
                            height: height,
                            bitsPerComponent: 8,
                            bytesPerRow: 4 * width,
                            space: CGColorSpaceCreateDeviceRGB(),
                            bitmapInfo: CGImageAlphaInfo.noneSkipLast.rawValue)
    if let cgImage = image.cgImage {
      context?.draw(cgImage, in: CGRect(x: 0, y: 0, width: width, height: height))
    } else {
      return nil
    }
  }
  
  func toUIImage() -> UIImage? {
    let bytesPerRow = width * 4
    
    if let imageContext = CGContext(data: UnsafeMutablePointer(mutating: pixels),
                                    width: width,
                                    height: height,
                                    bitsPerComponent: 8,
                                    bytesPerRow: bytesPerRow,
                                    space: CGColorSpaceCreateDeviceRGB(),
                                    bitmapInfo: CGImageAlphaInfo.noneSkipLast.rawValue),
      let cgImage = imageContext.makeImage() {
      return UIImage(cgImage: cgImage)
    } else {
      return nil
    }
  }
}

extension CGSize {

  func scaleRectSize(toFitIn rectSize: CGSize) -> CGSize {
    let widthFactor = width / rectSize.width
    let heightFactor = height / rectSize.height
    
    var resizeFactor = widthFactor
    if height > width {
      resizeFactor = heightFactor
    }
    
    let newSize = CGSize(width: width/resizeFactor, height: height/resizeFactor)
    return newSize
  }

}

extension UIImage {
  
  /// Returns a image that fills in newSize
  func resizedImage(newSize: CGSize) -> UIImage? {
    // Guard newSize is different
    if self.size == newSize {
      return self
    }
    
    UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0);
    self.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
    let newImage: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return newImage
  }
  
  /// Returns a resized image that fits in rectSize, keeping it's aspect ratio
  /// Note that the new image size is not rectSize, but within it.
  func resizedImageWithinRect(rectSize: CGSize) -> UIImage? {
    let newSize = size.scaleRectSize(toFitIn: rectSize)
    let resized = resizedImage(newSize: newSize)
    return resized
  }
}


