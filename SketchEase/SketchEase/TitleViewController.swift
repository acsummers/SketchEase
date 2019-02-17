//
//  ViewController.swift
//  SketchEase
//
//  Created by 19acs2 on 11/29/18.
//  Copyright © 2018 williamsCS. All rights reserved.
//

import UIKit

    //A view controller containing the main screen of the app
    class TitleViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

        var transitionImage: UIImage?
    
        
        override func viewWillAppear(_ animated: Bool) {
            self.navigationController?.isNavigationBarHidden = true
        }
        
        override func viewWillDisappear(_ animated: Bool) {
            self.navigationController?.isNavigationBarHidden = false
        }

        
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == "filter" {
                let destination = segue.destination
                if let filterViewController = destination as? FilterViewController,
                let toDisplay = transitionImage {
                    filterViewController.originalImage = toDisplay
                }
            }
        }
        
        @IBAction func takeNewPress(_ sender: UIButton) {
            pickImage(UIImagePickerControllerSourceType.camera)
        }
        @IBAction func chooseExistingPress(_ sender: UIButton) {
            pickImage(UIImagePickerControllerSourceType.photoLibrary)
        }
        
        
        //Code courtesy of Steven Freund, added to by Alexander Summers
        
        /*
         UIImagePickerControllerDelegate method to let user pick image.
         
         This method creates a new controller that pops up to get the
         user's choice.
         */
        func pickImage(_ sourceType : UIImagePickerControllerSourceType) {
            if UIImagePickerController.isSourceTypeAvailable(sourceType) {
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType = sourceType
                imagePicker.allowsEditing = false
                self.present(imagePicker, animated: true, completion: nil)
            }
        }
        
        /*
         Handler called when user has chosen an image.
         */
        func imagePickerController(_ picker: UIImagePickerController,
                                   didFinishPickingMediaWithInfo info: [String : Any]) {
            if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
                dismiss(animated:true, completion: nil)
                
                self.transitionImage = pickedImage
                self.performSegue(withIdentifier: "filter", sender: self)
                
            }
        }

}

