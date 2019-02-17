//
//  FilterViewController.swift
//  SketchEase
//
//  Created by 19acs2 on 11/29/18.
//  Copyright © 2018 williamsCS. All rights reserved.
//

import Foundation
import UIKit

/*
 The ViewController managing the 'Filter' view, in which the user can select filters for faces in their image.
 
 
 */
class FilterViewController : UIViewController {
    @IBOutlet weak var DisplayImageView: FilterableImageView!
    
    //Saves the image passed to the FilterView on load
    var originalImage: UIImage? {
        didSet {
            if let img = originalImage {
                filterableImage = FilterableImage(image: originalImage!)
                filterableImage!.detectFaces()
            }
        }
    }
    
    //Stores an internal Image representation of the image passed to the FilterView on load
    private var filterableImage : FilterableImage?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        DisplayImageView.image = filterableImage?.displayImage
        
    }
    
    //When the Filter button is pressed, allows the user to select a filter
    @IBAction func onFilterPress(_ sender: UIButton) {
        let filters : [String:Filter] = [
            "No Filter": PassThroughFilter(),
            "Redact" : BFilter(),
            "Black and White": BWFilter(),
            "Sepia": SepiaFilter(),
            "Ghost": InvertedBWFilter(),
            "High Contrast": HighContrastFilter(),
            "Medium Contrast": MediumHighContrastFilter(),
            "Low Contrast": LowHighContrastFilter()
        ]
        chooseItemFromList(Array(filters.keys), prompt: "Choose a filter") {
            self.filterableImage?.setFilter(filter: filters[$0]!)
            self.filterableImage?.applyFilters()
            self.DisplayImageView.image = self.filterableImage?.displayImage
        }
    }
    
    /**
     Enable the user to share the current image with other applications.
     You can connect this action to a UIBarButton to enable this functionality.
     
     Code courtesy of Stephen Freund
     */
    @IBAction private func shareImage(_ sender: UIBarButtonItem) {
        if let img = DisplayImageView.image {
            if let data = UIImagePNGRepresentation(img) {
                let filename = FileManager.default.urls(for: .documentDirectory,
                                                        in: .userDomainMask)[0].appendingPathComponent("copy.png")
                // Uncomment to show where the shared image is stored
                // on the file system:
                //   print("Shared image can be found at: \(filename)")
                try? data.write(to: filename)
            }
            
            let activityViewController = UIActivityViewController(activityItems: [img],
                                                                  applicationActivities: nil)
            activityViewController.popoverPresentationController?.sourceView = self.view
            activityViewController.popoverPresentationController?.barButtonItem = sender
            self.present(activityViewController, animated: true,
                         completion: nil)
        }
    }
    
    
}
