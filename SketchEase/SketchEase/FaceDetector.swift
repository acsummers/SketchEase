//
//  FaceDetector.swift
//  SketchEase
//
//  Created by 19acs2 on 11/29/18.
//  Copyright © 2018 williamsCS. All rights reserved.
//

import Foundation
import UIKit
import Vision

/**
 A class which wraps face detection capabilities
 */
class FaceDetector {
    init() {
        
    }
    
    /**Given an image, returns a CGRect bounding box array
    with faces detected within the image.
     
     -Parameter: Image
     -Returns: an array of CGRect bounding boxes normalized from 0-1.
     **/
    func detect(image: Image) -> [CGRect] {
        let imageRequestHandler : VNImageRequestHandler? = VNImageRequestHandler(cgImage: image.cgImage, options:[:])
        
        var toReturn : [CGRect] = []
        
        let faceDetectionRequest : VNDetectFaceRectanglesRequest = VNDetectFaceRectanglesRequest {
            request, error in
            if let results = request.results as? [VNFaceObservation] {
                toReturn.append(contentsOf: results.map({$0.boundingBox}))
            }
        }
        
        
        
        do {
            try imageRequestHandler!.perform([faceDetectionRequest])
        } catch let error as NSError {
            print("image request failed")
        }
        return toReturn
    }
}
