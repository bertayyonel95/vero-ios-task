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
    
    static let shared = CoreDataManager()
    private init() {}
    
    func write(data: CoreDataPO) {
        let context = persistentContainer.viewContext
        let newData = CDTask(context: context)
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
        context.insert(newData)
        do {
            try context.save()
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
}
