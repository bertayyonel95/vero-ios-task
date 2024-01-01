//
//  CoreDataManager.swift
//  vero-task-api
//
//  Created by Bertay Yönel on 31.12.2023.
//

import Foundation
import CoreData

class CoreDataManager {
    
    var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "TaskManager")
        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Unable to load persistent stores: \(error)")
            }
            container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
            container.viewContext.automaticallyMergesChangesFromParent = true
        }
        return container
    }()
    
    lazy var updateContext: NSManagedObjectContext = {
        let _updateContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        _updateContext.parent = self.persistentContainer.viewContext
        return _updateContext
    }()
    
    static let shared = CoreDataManager()
    private init() {}
    
    func write(data: CoreDataPO) {
        let newData = CDTask(context: updateContext)
        newData.businessUnit = data.businessUnit
        newData.businessUnitKey = data.businessUnitKey
        newData.colorCode = data.colorCode
        newData.isAvailableInTimeTrackingKioskMode = data.isAvailableInTimeTrackingKioskMode
        newData.parentTaskID = data.parentTaskID
        newData.preplanningBoardQuickSelect = data.preplanningBoardQuickSelect
        newData.sort = data.sort
        newData.task = data.task
        newData.taskDescription = data.taskDescription
        newData.title = data.title
        newData.wageType = data.wageType
        newData.workingTime = data.workingTime
        updateContext.insert(newData)
        do {
            try updateContext.save()
        } catch {
            print("error saving data")
        }
    }
    
    func fetch(onSuccess: @escaping ([CDTask]?) -> Void) {
        let context = persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<CDTask>(entityName: String(describing: CDTask.self))
        do {
            let items = try context.fetch(CDTask.fetchRequest()) as? [CDTask]
            onSuccess(items)
        } catch {
            print("error fetching data")
        }
    }
    
    func deleteAll() {
        LoadingManager.shared.show()
        let fetchRequest = NSFetchRequest<CDTask>(entityName: String(describing: CDTask.self))
        do {
            let objects = try updateContext.fetch(fetchRequest)
            for object in objects {
                updateContext.delete(object)
            }
            try updateContext.save()
            LoadingManager.shared.hide()
        } catch {
            print("error during deletion")
        }
    }
}
