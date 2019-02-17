//
//  SketchEaseTests.swift
//  SketchEaseTests
//
//  Created by 19acs2 on 11/29/18.
//  Copyright © 2018 williamsCS. All rights reserved.
//

import XCTest
@testable import SketchEase

class SketchEaseTests: XCTestCase {
    
    //Helper method to compare two Images pixel by pixel using Steve's PixelArray class
    func XCTAssertImagesEqual(_ img1: Image, _ img2: Image) {
        let arr1 = img1.asPixelArray()
        let arr2 = img2.asPixelArray()
        
        XCTAssertEqual(arr1.width, arr2.width)
        XCTAssertEqual(arr1.height, arr2.height)
        
        for i in 0..<arr1.width {
            for j in 0..<arr1.height {
                XCTAssertEqual(arr1[i, j].alpha, arr2[i, j].alpha)
                XCTAssertEqual(arr1[i, j].red, arr2[i, j].red)
                XCTAssertEqual(arr1[i, j].green, arr2[i, j].green)
                XCTAssertEqual(arr1[i, j].blue, arr2[i, j].blue)
            }
        }
    }
    
    //Helper method to compare two UIImages pixel by pixel using Steve's PixelArray class
    func XCTAssertUIImagesEqual(_ img1: UIImage, _ img2: UIImage) {
        let arr1 = PixelArray(image: img1)!
        let arr2 = PixelArray(image: img2)!
        
        XCTAssertEqual(arr1.width, arr2.width)
        XCTAssertEqual(arr1.height, arr2.height)
        
        for i in 0..<arr1.width {
            for j in 0..<arr1.height {
                XCTAssertEqual(arr1[i, j].alpha, arr2[i, j].alpha)
                XCTAssertEqual(arr1[i, j].red, arr2[i, j].red)
                XCTAssertEqual(arr1[i, j].green, arr2[i, j].green)
                XCTAssertEqual(arr1[i, j].blue, arr2[i, j].blue)
            }
        }
    }
    
    
    
    //Tests Image class to ensure that an Image created from a UIImage has property uiImage equal to the original UIImage
    func testImageInitUItoUI() {
        let uiImage = UIImage(named: "lotsoffaces.jpg")
        let i = Image(image: uiImage!)
        XCTAssertUIImagesEqual(uiImage!, i.uiImage)
        
    }
    
    //Tests Image class to ensure that an Image created from a CGImage has property cgImage equal to the original cgImage
    func testImageInitCGtoCG() {
        let uiImage = UIImage(named: "lotsoffaces.jpg")
        let cgImage = uiImage!.cgImage!
        let i = Image(image: cgImage)
        XCTAssertEqual(cgImage, i.cgImage)
    }
    
    //Tests Image class to ensure than an Image created from a CGImage has property uiImage equal to the original uiImage
    func testImageInitCGtoUI() {
        let uiImage = UIImage(named: "lotsoffaces.jpg")
        let cgImage = uiImage!.cgImage!
        let i = Image(image: cgImage)
        XCTAssertUIImagesEqual(uiImage!, i.uiImage)
    }
    
    //Tests Image class to ensure than an Image created from a UIImage has property cgImage equal to the original cgImage
    func testImageInitUItoCG() {
        let uiImage = UIImage(named: "lotsoffaces.jpg")
        let cgImage = uiImage!.cgImage!
        let i = Image(image: uiImage!)
        XCTAssertEqual(cgImage, i.cgImage)
    }
    
    //A unit test for FaceDetector using an image with 5 faces, tests if FaceDetector finds those five faces.
    func testFaceDetector() {
        let f = FaceDetector()
        let uiImage = UIImage(named: "lotsoffaces.jpg")
        let i = Image(image: uiImage!)
        XCTAssertEqual(f.detect(image: i).count, 5)
    }
    
    //Tests the Image helper method scaleRect
    func testImageScale() {
        let uiImage = UIImage(named: "lotsoffaces.jpg")!
        let i = Image(image: uiImage)
        
        let scaledRect = i.scaleRect(CGRect(origin: CGPoint(x: 0.5, y: 0.5), size: CGSize(width: 0.5, height: 0.5)))
        XCTAssertEqual(scaledRect.maxX, uiImage.size.width)
        XCTAssertEqual(scaledRect.maxY, uiImage.size.height)
        
        XCTAssertEqual(scaledRect.minX, uiImage.size.width/2)
        XCTAssertEqual(scaledRect.minY, uiImage.size.height/2)
    }
    
    //Tests the Image segment method by segmenting the image, and checking to see if the expected pixels correspond between the original and segmented image
    func testImageSegment() {
        let uiImage = UIImage(named: "lotsoffaces.jpg")!
        let originalImage = Image(image: uiImage)
        
        let nonScaledRect = CGRect(origin: CGPoint(x: 0.5, y: 0.5), size: CGSize(width: 0.5, height: 0.5))
        
        let finalImage = originalImage.segment(nonScaledRect)
        
        let ogPixels = originalImage.asPixelArray()
        let finalPixels = finalImage.asPixelArray()
        
        for i in 0..<finalPixels.width {
            for j in 0..<finalPixels.height {
                let halfWidth = Int(uiImage.size.width/2)
                let halfHeight = Int(uiImage.size.height/2)
                
                XCTAssertEqual(ogPixels[halfWidth + i, halfHeight + j].alpha, finalPixels[i, j].alpha)
                XCTAssertEqual(ogPixels[halfWidth + i, halfHeight + j].blue, finalPixels[i, j].blue)
                XCTAssertEqual(ogPixels[halfWidth + i, halfHeight + j].green, finalPixels[i, j].green)
                XCTAssertEqual(ogPixels[halfWidth + i, halfHeight + j].red, finalPixels[i, j].red)
            }
        }
        
    }
    
    //Tests the Image merge method by segmenting the image and merging the
    //segment back in, then checking to see if that final image is equal to the original
    func testImageMerge() {
        let uiImage = UIImage(named: "lotsoffaces.jpg")!
        let originalImage = Image(image: uiImage)
        
        let nonScaledRect = CGRect(origin: CGPoint(x: 0.5, y: 0.5), size: CGSize(width: 0.5, height: 0.5))
        
        let finalImage = originalImage.segment(nonScaledRect)
        
        let merged = originalImage.merge(nonScaledRect, finalImage)
        
        XCTAssertImagesEqual(originalImage, merged)
        
    }
    
    
    //Checks that the BFilter works by applying the filter to the image, then checking that each pixel is black.
    func testBFilter() {
        let uiImage = UIImage(named: "lotsoffaces.jpg")
        let i = Image(image: uiImage!)
        let f = BFilter()
        let blackVersion = f.filter(i)
        let blackTest = PixelArray(image: blackVersion.uiImage)!
        
        for i in 0..<blackTest.width {
            for j in 0..<blackTest.height {
                XCTAssertEqual(blackTest[i, j].alpha, Pixel.black.alpha)
                XCTAssertEqual(blackTest[i, j].blue, Pixel.black.blue)
                XCTAssertEqual(blackTest[i, j].green, Pixel.black.green)
                XCTAssertEqual(blackTest[i, j].red, Pixel.black.red)
            }
        }
        
    }
    
    //An integration test checking that segmenting an image, filtering that segment, and merging it back into the original Image works as intended.
    func testImageFilter() {
        let uiImage = UIImage(named: "lotsoffaces.jpg")
        let img = Image(image: uiImage!)
        let f = BFilter()
        
        let scalePortion = CGRect(origin: CGPoint(x: 0.2, y:0), size: CGSize(width: 0.1, height: 0.2))
        
        let toFilter = img.segment(scalePortion)
    
        let redacted = f.filter(toFilter)
        
        let final = img.merge(scalePortion, redacted)
        
        //Note: can place a break point here to observe the image visually
        let finalTest = final.uiImage
    
        let scaledRect = img.scaleRect(scalePortion)
        let finalArr = final.asPixelArray()
        let originalArr = img.asPixelArray()
        
       
        
        for i in 0..<finalArr.width {
            for j in 0..<finalArr.height {
                if i >= Int(scaledRect.minX) && i < Int(scaledRect.maxX) && j >= Int(scaledRect.minY) && j < Int(scaledRect.maxY) {
                    XCTAssertEqual(finalArr[i, j].alpha, Pixel.black.alpha)
                    XCTAssertEqual(finalArr[i, j].blue, Pixel.black.blue)
                    XCTAssertEqual(finalArr[i, j].green, Pixel.black.green)
                    XCTAssertEqual(finalArr[i, j].red, Pixel.black.red)
                }
                else {
                    XCTAssertEqual(finalArr[i, j].alpha, originalArr[i, j].alpha)
                    XCTAssertEqual(finalArr[i, j].blue, originalArr[i, j].blue)
                    XCTAssertEqual(finalArr[i, j].green, originalArr[i, j].green)
                    XCTAssertEqual(finalArr[i, j].red, originalArr[i, j].red)
                }
            }
        }
        
    }
    
    //An integration test to see that the FilterableImage works identically to using the components separately to apply filters to detected faces
    func testFilterableImage() {
        let uiImage = UIImage(named: "lotsoffaces.jpg")
        var filterableImage = FilterableImage(image: uiImage!)
        filterableImage.detectFaces()
        filterableImage.setFilter(filter: BFilter())
        
        let i = Image(image: uiImage!)
        let d = FaceDetector()
        let f = BFilter()
        
        var image : Image = i
        let detectedRects = d.detect(image: i)
        for rect in detectedRects {
            let faceBox = i.segment(rect)
            let filteredFace = f.filter(faceBox)
            image = image.merge(rect, filteredFace)
        }
        
        XCTAssertUIImagesEqual(i.uiImage, filterableImage.originalImage)
        XCTAssertUIImagesEqual(image.uiImage, filterableImage.displayImage)
        
    }
    
}
