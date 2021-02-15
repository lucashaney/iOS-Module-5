//
//  String+AddText.swift
//  MyLocations
//
//  Created by Lucas Haney on 2/14/21.
//

import UIKit

// Extension for string in details labels
extension String {
    mutating func add(text: String?, separatedBy separator: String = "") {
        if let text = text {
            if !isEmpty {
                self += separator
            }
            self += text
        }
    }
}
