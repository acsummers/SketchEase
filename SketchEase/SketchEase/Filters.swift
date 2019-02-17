//
//  Filters.swift
//  SketchEase
//
//  Created by Alexander Summers on 12/4/18.
//  Copyright © 2018 williamsCS. All rights reserved.
//

import Foundation

//Filters that perform image transformations

/**A filter which just returns the original image
 */
class PassThroughFilter : Filter {
    /**
     Returns the original image
     
     -Parameter img: the original Image
     -Returns: the original Image
     */
    func filter(_ img: Image) -> Image {
        return img
    }
}

/**A filter which sets the largest elliptical area within the bounds of the image to black
 */
class BFilter : Filter {
    
    /**
     Returns the original image with the pixels of the largest elliptical area within the bounds of the image its pixels set to black
     
     -Parameter img: the original Image
     -Returns: the filtered Image
     */
    func filter(_ img: Image) -> Image {
        let pixelArr = PixelArray(image: img.uiImage)
        for i in 0..<pixelArr!.width {
            for j in 0..<pixelArr!.height {
                if inEllipse(i: i, j: j, arrWidth: pixelArr!.width, arrHeight: pixelArr!.height) {
                    pixelArr![i, j] = Pixel.black
                }
            }
        }
        return Image(image: pixelArr!.toUIImage()!)
    }
    
    private func inEllipse(i: Int, j: Int, arrWidth: Int, arrHeight: Int) -> Bool {
        let xRadius = arrWidth/2
        let yRadius = arrHeight/2
        return (pow(Float(i) - Float(xRadius), 2) / pow(Float(xRadius), 2)) + (pow(Float(j) - Float(yRadius), 2) / pow(Float(yRadius), 2)) <= 1

    }
    
}

/**A filter which converts the largest elliptical area within the bounds of the image to black and white
 */
class BWFilter : Filter {
    
    /**
     Returns the image with the largest elliptical area within the bounds of the image set to a black and white color space
     
     -Parameter img: the original Image
     -Returns: the filtered Image
     */
    func filter(_ img: Image) -> Image {
        let pixelArr = PixelArray(image: img.uiImage)
        for i in 0..<pixelArr!.width {
            for j in 0..<pixelArr!.height {
                let red = Float(pixelArr![i, j].red)
                let green = Float(pixelArr![i, j].green)
                let blue = Float(pixelArr![i, j].blue)
                let average = UInt8((red + green + blue) / 3.0)
                
                if inEllipse(i: i, j: j, arrWidth: pixelArr!.width, arrHeight: pixelArr!.height) {
                    pixelArr![i, j] = Pixel(red: average, green: average, blue: average, alpha: pixelArr![i, j].alpha)
                }
                
            }
        }
        return Image(image: pixelArr!.toUIImage()!)
    }
    private func inEllipse(i: Int, j: Int, arrWidth: Int, arrHeight: Int) -> Bool {
        let xRadius = arrWidth/2
        let yRadius = arrHeight/2
        return (pow(Float(i) - Float(xRadius), 2) / pow(Float(xRadius), 2)) + (pow(Float(j) - Float(yRadius), 2) / pow(Float(yRadius), 2)) <= 1
        
    }
}

/**A filter which converts the largest elliptical area within the bounds of the image to sepia
 */
class SepiaFilter : Filter {
    
 /**
     Returns the image with the largest elliptical area within the bounds of the image set to a sepia color space
     
     -Parameter img: the original Image
     -Returns: the filtered Image
  */
 func filter(_ img: Image) -> Image {
    let pixelArr = PixelArray(image: img.uiImage)
    
    
    for i in 0..<pixelArr!.width {
        for j in 0..<pixelArr!.height {
            
            //Sepia ratios courtesy of StackOverflow: https://stackoverflow.com/questions/1061093/how-is-a-sepia-tone-created
            var red = Float(pixelArr![i, j].red) * 0.393 + Float(pixelArr![i, j].green) * 0.769 + Float(pixelArr![i, j].blue) * 0.189
            if red > 255 {
                red = 255
            }
            var green = Float(pixelArr![i, j].red) * 0.349 + Float(pixelArr![i, j].green) * 0.686 + Float(pixelArr![i, j].blue) * 0.168
            if green > 255 {
                green = 255
            }
            var blue = Float(pixelArr![i, j].red) * 0.272 + Float(pixelArr![i, j].green) * 0.534 + Float(pixelArr![i, j].blue) * 0.131
            if blue > 255 {
                blue = 255
            }
            if inEllipse(i: i, j: j, arrWidth: pixelArr!.width, arrHeight: pixelArr!.height) {
                pixelArr![i, j] = Pixel(red: UInt8(red), green: UInt8(green), blue: UInt8(blue), alpha: pixelArr![i, j].alpha)
            }
            
        }
    }
    return Image(image: pixelArr!.toUIImage()!)
 }
    private func inEllipse(i: Int, j: Int, arrWidth: Int, arrHeight: Int) -> Bool {
        let xRadius = arrWidth/2
        let yRadius = arrHeight/2
        return (pow(Float(i) - Float(xRadius), 2) / pow(Float(xRadius), 2)) + (pow(Float(j) - Float(yRadius), 2) / pow(Float(yRadius), 2)) <= 1
        
    }
 }

/**A filter which converts the largest elliptical area within the bounds of the image to a high contrast image
 */
class HighContrastFilter : Filter {
    
    /**
     Returns the image with the largest elliptical area within the bounds of the image set to a high contrast image
     
     -Parameter img: the original Image
     -Returns: the filtered Image
     */
    func filter(_ img: Image) -> Image {
        
        let pixelArray = PixelArray(image: img.uiImage)
        
        for i in 0..<pixelArray!.width {
            for j in 0..<pixelArray!.height {
                var red = Float(pixelArray![i, j].red)*5
                if red > 255 {
                    red = 255
                }
                var blue = Float(pixelArray![i, j].blue)*5
                if blue > 255 {
                    blue = 255
                }
                var green = Float(pixelArray![i, j].green)*5
                if green > 255 {
                    green = 255
                }
                if inEllipse(i: i, j: j, arrWidth: pixelArray!.width, arrHeight: pixelArray!.height) {
                    pixelArray![i, j] = Pixel(red: UInt8(red), green: UInt8(green), blue: UInt8(blue), alpha: pixelArray![i, j].alpha)
                }
            }
        }
        return Image(image: pixelArray!.toUIImage()!)
    }
    private func inEllipse(i: Int, j: Int, arrWidth: Int, arrHeight: Int) -> Bool {
        let xRadius = arrWidth/2
        let yRadius = arrHeight/2
        return (pow(Float(i) - Float(xRadius), 2) / pow(Float(xRadius), 2)) + (pow(Float(j) - Float(yRadius), 2) / pow(Float(yRadius), 2)) <= 1
        
    }
 }

/**A filter which converts the largest elliptical area within the bounds of the image to a medium-high contrast image
 */
class MediumHighContrastFilter : Filter {
    
    /**
     Returns the original image with the largest elliptical area within the bounds of the image set to a medium-high contrast image
     
     -Parameter img: the original Image
     -Returns: the filtered Image
     */
    func filter(_ img: Image) -> Image {
        
        let pixelArray = PixelArray(image: img.uiImage)
        
        for i in 0..<pixelArray!.width {
            for j in 0..<pixelArray!.height {
                var red = Float(pixelArray![i, j].red)*3
                if red > 255 {
                    red = 255
                }
                var blue = Float(pixelArray![i, j].blue)*3
                if blue > 255 {
                    blue = 255
                }
                var green = Float(pixelArray![i, j].green)*3
                if green > 255 {
                    green = 255
                }
                if inEllipse(i: i, j: j, arrWidth: pixelArray!.width, arrHeight: pixelArray!.height) {
                    pixelArray![i, j] = Pixel(red: UInt8(red), green: UInt8(green), blue: UInt8(blue), alpha: pixelArray![i, j].alpha)
                }
            }
        }
        return Image(image: pixelArray!.toUIImage()!)
    }
    
    private func inEllipse(i: Int, j: Int, arrWidth: Int, arrHeight: Int) -> Bool {
        let xRadius = arrWidth/2
        let yRadius = arrHeight/2
        return (pow(Float(i) - Float(xRadius), 2) / pow(Float(xRadius), 2)) + (pow(Float(j) - Float(yRadius), 2) / pow(Float(yRadius), 2)) <= 1
        
    }
}

/**A filter which converts the largest elliptical area within the bounds of the image to a low contrast image
 */
class LowHighContrastFilter : Filter {
    
    /**
     Returns the original image with the largest elliptical area within the bounds of the image set to a low contrast image
     
     -Parameter img: the original Image
     -Returns: the filtered Image
     */
    func filter(_ img: Image) -> Image {
        
        let pixelArray = PixelArray(image: img.uiImage)
        
        for i in 0..<pixelArray!.width {
            for j in 0..<pixelArray!.height {
                var red = Float(pixelArray![i, j].red)*1.5
                if red > 255 {
                    red = 255
                }
                var blue = Float(pixelArray![i, j].blue)*1.5
                if blue > 255 {
                    blue = 255
                }
                var green = Float(pixelArray![i, j].green)*1.5
                if green > 255 {
                    green = 255
                }
                if inEllipse(i: i, j: j, arrWidth: pixelArray!.width, arrHeight: pixelArray!.height) {
                    pixelArray![i, j] = Pixel(red: UInt8(red), green: UInt8(green), blue: UInt8(blue), alpha: pixelArray![i, j].alpha)
                }
            }
        }
        return Image(image: pixelArray!.toUIImage()!)
    }
    private func inEllipse(i: Int, j: Int, arrWidth: Int, arrHeight: Int) -> Bool {
        let xRadius = arrWidth/2
        let yRadius = arrHeight/2
        return (pow(Float(i) - Float(xRadius), 2) / pow(Float(xRadius), 2)) + (pow(Float(j) - Float(yRadius), 2) / pow(Float(yRadius), 2)) <= 1
        
    }
}


/**A filter which converts the largest elliptical area within the bounds of the image to an inverted black and white image
 */
class InvertedBWFilter : Filter {
    /**
     Returns the original image with the largest elliptical area within the bounds of the image set to an inverted black and white image
     
     -Parameter img: the original Image
     -Returns: the filtered Image
     */
    func filter(_ img: Image) -> Image {
        let pixelArray = PixelArray(image: img.uiImage)
        
        for i in 0..<pixelArray!.width {
            for j in 0..<pixelArray!.height {
                let red = Float(pixelArray![i, j].red)
                let green = Float(pixelArray![i, j].green)
                let blue = Float(pixelArray![i, j].blue)
                let average = UInt8((red + green + blue) / 3.0)
                
                let inverted = 255 - average
                
                if inEllipse(i: i, j: j, arrWidth: pixelArray!.width, arrHeight: pixelArray!.height) {
                    pixelArray![i, j] = Pixel(red: UInt8(inverted), green: UInt8(inverted), blue: UInt8(inverted), alpha: pixelArray![i, j].alpha)
                }
            }
        }
        return Image(image: pixelArray!.toUIImage()!)
    }
    private func inEllipse(i: Int, j: Int, arrWidth: Int, arrHeight: Int) -> Bool {
        let xRadius = arrWidth/2
        let yRadius = arrHeight/2
        return (pow(Float(i) - Float(xRadius), 2) / pow(Float(xRadius), 2)) + (pow(Float(j) - Float(yRadius), 2) / pow(Float(yRadius), 2)) <= 1
        
    }
}
