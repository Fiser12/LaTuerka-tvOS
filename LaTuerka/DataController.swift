/*import UIKit
import CoreData
class DataController {
    static let sharedInstance = DataController()
    var managedObjectContext: NSManagedObjectContext
    init() {
        // This resource is the same name as your xcdatamodeld contained in your project.
        guard let modelURL = NSBundle.mainBundle().URLForResource("Up_and_Running_With_Core_Data", withExtension:"momd") else {
            fatalError("Error loading model from bundle")
        }
        // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
        guard let mom = NSManagedObjectModel(contentsOfURL: modelURL) else {
            fatalError("Error initializing mom from: \(modelURL)")
        }
        let psc = NSPersistentStoreCoordinator(managedObjectModel: mom)
        self.managedObjectContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        self.managedObjectContext.persistentStoreCoordinator = psc
        
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        let docURL = urls[urls.endIndex-1]
        /* The directory the application uses to store the Core Data store file.
        This code uses a file named "DataModel.sqlite" in the application's documents directory.
        */
        let storeURL = docURL.URLByAppendingPathComponent("Up_and_Running_With_Core_Data.sqlite")
        do {
            try psc.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: storeURL, options: nil)
        } catch {
            fatalError("Error migrating store: \(error)")
        }
    }
    func saveEpisodio(id:String, name:String, url:String, fecha:NSDate) -> Bool{
        
        // create an instance of our managedObjectContext
        let moc = DataController().managedObjectContext
        let episodio:EpisodioEntity? = loadEpisodio(id)
        if(episodio==nil){
            // we set up our entity by selecting the entity and context that we're targeting
            let entity = NSEntityDescription.insertNewObjectForEntityForName("EpisodioEntity", inManagedObjectContext: moc) as! EpisodioEntity
        
            // add our data
            entity.setValue(id, forKey: "id")
            entity.setValue(url, forKey: "urlDir")
            entity.setValue(name, forKey: "nombre")
            entity.setValue(fecha, forKey: "fecha")

            // we save our entity
            do {
                try moc.save()
                return true
            } catch {
                fatalError("Failure to save context: \(error)")
                return false
            }
        }
        else
        {
            return false
        }
    }
    func loadEpisodio(id:String) -> EpisodioEntity? {
        let moc = DataController().managedObjectContext
        let personFetch = NSFetchRequest(entityName: "EpisodioEntity")
        
        do {
            let episodios:[EpisodioEntity] = try moc.executeFetchRequest(personFetch) as! [EpisodioEntity]
            let episodio:EpisodioEntity? = episodios.filter { $0.id!==id }.first
            return episodio;
        } catch {
            fatalError("Failed to fetch episode: \(error)")
        }
        return nil;
    }
    func loadEpisodios(programa:String) -> [EpisodioEntity]? {
        let moc = DataController().managedObjectContext
        let personFetch = NSFetchRequest(entityName: "EpisodioEntity")
        
        do {
            var episodios:[EpisodioEntity] = try moc.executeFetchRequest(personFetch) as! [EpisodioEntity]
            episodios = episodios.filter { $0.programa!==programa }
            
            return episodios;
        } catch {
            fatalError("Failed to fetch episode: \(error)")
        }
        return nil;
    }


}
*/
