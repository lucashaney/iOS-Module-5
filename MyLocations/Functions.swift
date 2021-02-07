//
//  Functions.swift
//  MyLocations
//
//  Created by Lucas Haney on 2/7/21.
//

import Foundation

// Adds delay before exiting page after the HUD item is displayed
func afterDelay(_ seconds: Double, run: @escaping () -> Void) {
    DispatchQueue.main.asyncAfter(deadline: .now() + seconds, execute: run)
}
