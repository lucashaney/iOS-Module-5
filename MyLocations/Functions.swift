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

// Contains path to app's documents directory
let applicationDocumentsDirectory: URL = {
    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    return paths[0]
}()

let CoreDataSaveFailedNotification = Notification.Name("CoreDataSaveFailedNotification")

// Handles fatal core data errors
func fatalCoreDataError(_ error: Error) {
    print("*** Fatal error: \(error)")
    NotificationCenter.default.post(name: CoreDataSaveFailedNotification, object: nil)
}

