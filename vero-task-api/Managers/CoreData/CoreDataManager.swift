//
//  CoreDataManager.swift
//  vero-task-api
//
//  Created by Bertay Yönel on 31.12.2023.
//

import Foundation
import CoreData

class CoreDataManager {
    
    private lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
            let persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)

            let fileManager = FileManager.default
            let storeName = "\("TaskManager").sqlite"

            let documentsDirectoryURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]

            let persistentStoreURL = documentsDirectoryURL.appendingPathComponent(storeName)

            do {
                let options = [ NSInferMappingModelAutomaticallyOption : true,
                                NSMigratePersistentStoresAutomaticallyOption : true]

                try persistentStoreCoordinator.addPersistentStore(ofType: NSSQLiteStoreType,
                                                                  configurationName: nil,
                                                                  at: persistentStoreURL,
                                                                  options: options)
            } catch {
                fatalError("Unable to Load Persistent Store")
            }
            
            return persistentStoreCoordinator
    }()
    
    private lazy var managedObjectModel: NSManagedObjectModel = {
            guard let modelURL = Bundle.main.url(forResource: "TaskManager", withExtension: "momd") else {
                fatalError("Unable to Find Data Model")
            }

            guard let managedObjectModel = NSManagedObjectModel(contentsOf: modelURL) else {
                fatalError("Unable to Load Data Model")
            }
            
            return managedObjectModel
    }()
    
    private(set) lazy var managedObjectContext: NSManagedObjectContext = {
        let managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.parent = self.privateManagedObjectContext
        return managedObjectContext
    }()

    private lazy var privateManagedObjectContext: NSManagedObjectContext = {
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = self.persistentStoreCoordinator

        return managedObjectContext
    }()
    
    static let shared = CoreDataManager()
    private init(){}
    
    func saveChanges() {
        managedObjectContext.performAndWait {
            do {
                if self.managedObjectContext.hasChanges {
                    try self.managedObjectContext.save()
                }
            } catch {
                let saveError = error as NSError
                print("Unable to Save Changes of Managed Object Context")
                print("\(saveError), \(saveError.localizedDescription)")
            }

            self.privateManagedObjectContext.performAndWait {
                do {
                    if self.privateManagedObjectContext.hasChanges {
                        try self.privateManagedObjectContext.save()
                    }
                } catch {
                    let saveError = error as NSError
                    print("Unable to Save Changes of Private Managed Object Context")
                    print("\(saveError), \(saveError.localizedDescription)")
                }
            }
        }
    }
    
    func write(data: CoreDataPO) {
        let newData = poToCDAdapter(data: data, context: managedObjectContext)
        if newData != nil && data != nil {
            managedObjectContext.insert(newData)
        }
        saveChanges()
    }
    
    func fetch(onSuccess: @escaping ([CDTask]?) -> Void) {
        do {
            let items = try managedObjectContext.fetch(CDTask.fetchRequest()) as? [CDTask]
            onSuccess(items)
        } catch {
            print("error fetching data")
        }
    }
    
    func deleteAll() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "CDTask")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do {
            try managedObjectContext.execute(deleteRequest)
            saveChanges()
        } catch {
            print("error during deletion")
        }
        
    }
}
