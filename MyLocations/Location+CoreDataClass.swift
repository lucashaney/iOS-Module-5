//
//  Location+CoreDataClass.swift
//  MyLocations
//
//  Created by Lucas Haney on 2/13/21.
//
//

import Foundation
import CoreData
import MapKit

@objc(Location)
public class Location: NSManagedObject, MKAnnotation {
    
    public var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2DMake(latitude, longitude)
    }
    
    // Pin title
    public var title: String? {
        if locationDescription.isEmpty {
            return "(No Description)"
        } else {
            return locationDescription
        }
    }
    
    // Pin subtitle
    public var subtitle: String? {
        return category
    }
    
    // Determines if object has a photo
    var hasPhoto: Bool {
        return photoID != nil
    }
    
    // Computes URL for photo
    var photoURL: URL {
        assert(photoID != nil, "No photo ID set")
        let filename = "Photo-\(photoID!.intValue).jpg"
        return applicationDocumentsDirectory.appendingPathComponent(filename)
    }
    
    // Returns UIImage by loading image file
    var photoImage: UIImage? {
        return UIImage(contentsOfFile: photoURL.path)
    }
    
    // Generates readable unique ID
    class func nextPhotoID() -> Int {
        let userDefaults = UserDefaults.standard
        let currentID = userDefaults.integer(forKey: "PhotoID") + 1
        userDefaults.set(currentID, forKey: "PhotoID")
        userDefaults.synchronize()
        return currentID
    }
    
    // Removes photo 
    func removePhotoFile() {
        if hasPhoto {
            do {
                try FileManager.default.removeItem(at: photoURL)
            } catch {
                print("Error removing file : \(error)")
            }
        }
    }
}
