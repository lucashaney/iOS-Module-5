//
//  LocationsView.swift
//  MyLocations
//
//  Created by Lucas Haney on 2/13/21.
//

import UIKit
import CoreLocation
import CoreData

class LocationsViewContoller: UITableViewController {

    // Properties
    var managedObjectContext: NSManagedObjectContext!
    lazy var fetchedResultsController: NSFetchedResultsController<Location> = {
        let fetchRequest = NSFetchRequest<Location>()
        
        let entity = Location.entity()
        fetchRequest.entity = entity
        
        let sort1 = NSSortDescriptor(key: "category", ascending: true)
        let sort2 = NSSortDescriptor(key: "date", ascending: true)
        fetchRequest.sortDescriptors = [sort1, sort2]
        fetchRequest.fetchBatchSize = 20
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.managedObjectContext, sectionNameKeyPath: "category", cacheName: "Locations")
        fetchedResultsController.delegate = self
        return fetchedResultsController
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        performFetch()
        navigationItem.rightBarButtonItem = editButtonItem
    }
        
    // MARK:- Helper Methods
    // Performs reading from SQLite file
    func performFetch() {
        do {
            try fetchedResultsController.performFetch()
        } catch {
            fatalCoreDataError(error)
        }
    }
    
    // Deinitilizes fetching when no longer neeeded
    deinit {
        fetchedResultsController.delegate = nil
    }

    // MARK:- Table View Delegates
    // Sets number of rows
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionInfo = fetchedResultsController.sections![section]
        return sectionInfo.numberOfObjects
    }
    
    // Adds data to rows and uses LocationCell file to edit
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LocationCell", for: indexPath) as! LocationCell
        
        let location = fetchedResultsController.object(at: indexPath)
        cell.configure(for: location)
        return cell
    }
    
    // Editing style for deleting rows
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let location = fetchedResultsController.object(at: indexPath)
            location.removePhotoFile()
            managedObjectContext.delete(location)
            do {
                try managedObjectContext.save()
            } catch {
                fatalCoreDataError(error)
            }
        }
    }
    
    // Returns number of section based on number of different categories
    override func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsController.sections!.count
    }
    
    // Returns section name
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let sectionInfo = fetchedResultsController.sections![section]
        return sectionInfo.name.uppercased()
    }
    
    // Overrides properties for view for the header of each section in the locations table
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let labelRect = CGRect(x: 15, y: tableView.sectionHeaderHeight - 14, width: 300, height: 14)
        let label = UILabel(frame: labelRect)
        label.font = UIFont.boldSystemFont(ofSize: 11)
        label.text = tableView.dataSource!.tableView!(tableView, titleForHeaderInSection: section)
        label.textColor = UIColor(white: 1.0, alpha: 0.6)
        label.backgroundColor = UIColor.clear
        
        let separatorRect = CGRect(x: 15, y: tableView.sectionHeaderHeight - 0.5, width: tableView.bounds.size.width - 15, height: 0.5)
        let separator = UIView(frame: separatorRect)
        separator.backgroundColor = tableView.separatorColor
        
        let viewRect = CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.sectionHeaderHeight)
        let view = UIView(frame: viewRect)
        view.backgroundColor = UIColor(white: 0, alpha: 0.85)
        view.addSubview(label)
        view.addSubview(separator)
        return view
    }
    
    // MARK:- Navigation
    // Navigation to Tag Location view 
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EditLocation" {
            let controller = segue.destination as! LocationDetailsViewController
            controller.managedObjectContext = managedObjectContext
            if let indexPath = tableView.indexPath(for: sender as! UITableViewCell) {
                let location = fetchedResultsController.object(at: indexPath)
                controller.locationToEdit = location
            }
        }
    }
}

// MARK:- NSFetchedResultsController Delegate Extension
extension LocationsViewContoller: NSFetchedResultsControllerDelegate {
    
    // Controller for when user is editing a location property
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        //print("*** controllerWillChangeContent")
        tableView.beginUpdates()
    }
    
    // Controller for the different types of editing that will occur
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch type {
        case .insert:
            print("*** NSFetchedResultsChangeInsert (object)")
            tableView.insertRows(at: [newIndexPath!], with: .fade)
            
        case .delete:
            print("*** NSFetchedResultsChangeDelete (object)")
            tableView.deleteRows(at: [indexPath!], with: .fade)
            
        case .update:
            print("*** NSFetchedResultsChangeUpdate (object)")
            if let cell = tableView.cellForRow(at: indexPath!) as? LocationCell {
                let location = controller.object(at: indexPath!) as! Location
                cell.configure(for: location)
            }

        case .move:
            print("*** NSFetchedResultsChangeMove (object)")
            tableView.deleteRows(at: [indexPath!], with: .fade)
            tableView.insertRows(at: [newIndexPath!], with: .fade)
        
        @unknown default:
            fatalError("Unhandled switch case of NSFetchedResultsChangeType")
        }
    }
    
    // Controller for category change
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        
        switch type {
        case .insert:
            print("*** NSFetchedResultsChangeInsert (section)")
            tableView.insertSections(IndexSet(integer: sectionIndex), with: .fade)
        
        case .delete:
            print("*** NSFetchedResultsChangeDelete (section)")
            tableView.deleteSections(IndexSet(integer: sectionIndex), with: .fade)
            
        case .update:
            print("*** NSFetchedResultsChangeUpdate (section)")
        
        case .move:
            print("*** NSFetchedResultsChangeMove (section)")
        
        @unknown default:
            fatalError("Unhandled switch case of NSFetchedResultsChangeType")
        }
    }
    
    // Controller to end updates when user is done editing everything
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        //print("*** controllerDidChangeContent")
        tableView.endUpdates()
    }
}
