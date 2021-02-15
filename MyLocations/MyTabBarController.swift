//
//  MyTabBarController.swift
//  MyLocations
//
//  Created by Lucas Haney on 2/14/21.
//

import UIKit

// Overrides tab bar to light 
class MyTabBarController: UITabBarController {
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override var childForStatusBarStyle: UIViewController? {
        return nil
    }
}
