//
//  MyImagePickerController.swift
//  MyLocations
//
//  Created by Lucas Haney on 2/14/21.
//

import UIKit

// Overrides status bar style to light color
class MyImagePickerController: UIImagePickerController {
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
