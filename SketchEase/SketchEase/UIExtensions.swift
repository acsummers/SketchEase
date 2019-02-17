//
//  UIExtensions
//  PhotoMosaics
// Courtesy of Steven Freund

import Foundation
import UIKit
import CoreGraphics

/**
 A UIViewController extension to support easily selecting an item
 from a list via an alert sheet.
 */
public extension UIViewController {
  
  /**
   
   Pop up an alert to let the user select an item from a list of
   provided items.  The alert is dismissed an the completion handler
   called with the chosen item.  If the user cancels without selecting
   an item, the completion handler will not be called.
   
   You may use this method with values of any type that are
   CustomStringConvertible.  Example:
   
   ```
   let choices = [ "Chocolate", "Vanilla", "Banana" ]
     let flavor = chooseItemFromList(choices, prompt: "Choose Flavor") {
     if flavor == "Vanilla" {
       ...
     }
   }
   ```
   
   or:
   
   ```
   let numbers = [ 1, 3, 5, 7 ]
   let pick = chooseItemFromList(numbers, prompt: "Pick your favorite number") {
     print(pick * 2)
   }
   ```
   
   - Parameter items: the items to choose from
   - Parameter prompt: prompt given to the user
   - Parameter completion: the function to call on the chosen item
   
   */
  public func chooseItemFromList<T : CustomStringConvertible>(_ items : [T],
                                                              prompt : String?,
                                                              completion: @escaping (_ item : T) -> Void) {
    let alert = UIAlertController(title: prompt, message: nil, preferredStyle: .alert)
    for item in items {
      let action = UIAlertAction(title: "\(item)", style: .default) { _ in
        completion(item)
      }
      alert.addAction(action)
    }
    
    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) {
      (_) in
    }
    alert.addAction(cancelAction)
    self.present(alert, animated: true)
  }
}



