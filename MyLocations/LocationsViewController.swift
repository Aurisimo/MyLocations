import UIKit
import CoreData
import CoreLocation

class LocationsViewController : UITableViewController, NSFetchedResultsControllerDelegate {
   
    var managedObjectContext: NSManagedObjectContext!
    lazy var fetchedResultController: NSFetchedResultsController<Location> = {
        let fetchRequest = NSFetchRequest<Location>()
        
        let entity = Location.entity()
        fetchRequest.entity = entity
        
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: true)
        fetchRequest.sortDescriptors?.append(sortDescriptor)
        
        fetchRequest.fetchBatchSize = 20
        
        let fetchedResultController = NSFetchedResultsController<Location>(fetchRequest: fetchRequest, managedObjectContext: self.managedObjectContext, sectionNameKeyPath: nil, cacheName: "Locations")
        
        fetchedResultController.delegate = self
        return fetchedResultController
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        performFetch()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultController.sections![section].numberOfObjects
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "LocationCell", for: indexPath) as! LocationCell
        
        let location = fetchedResultController.object(at: indexPath)
        
        cell.configure(for: location)

        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EditLocation" {
            let controller = segue.destination as! LocationDetailsViewController
            
            controller.managedObjectContext = managedObjectContext

            if let indexPath = tableView.indexPath(for: sender as! UITableViewCell) {
                controller.locationToEdit = fetchedResultController.object(at: indexPath)
            }
        }
    }
    
    deinit {
        fetchedResultController.delegate = nil
    }
    
    //MARK:- Helper methods
    func performFetch() {
        do {
            try fetchedResultController.performFetch()
        } catch {
            fatalCoreDataError(error)
        }
    }
}
