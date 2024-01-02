//
//  HelperFunctions.swift
//  vero-task-api
//
//  Created by Bertay Yönel on 1.01.2024.
//

import Foundation
import CoreData

func cdToPoAdapter(task: CDTask) -> CoreDataPO {
    let coreData = CoreDataPO()
    coreData.businessUnit = task.businessUnit ?? .empty
    coreData.businessUnitKey = task.businessUnitKey
    coreData.colorCode = task.colorCode ?? .empty
    coreData.parentTaskID = task.parentTaskID ?? .empty
    coreData.preplanningBoardQuickSelect = task.preplanningBoardQuickSelect
    coreData.sort = task.sort ?? .empty
    coreData.task = task.task ?? .empty
    coreData.taskDescription = task.taskDescription ?? .empty
    coreData.title = task.title ?? .empty
    coreData.wageType = task.wageType ?? .empty
    coreData.workingTime = task.workingTime
    return coreData
}

func generatePO(with item: TaskResponse) -> CoreDataPO {
    let data = CoreDataPO()
    data.businessUnit = item.businessUnit
    data.businessUnitKey = item.businessUnitKey
    data.colorCode = item.colorCode
    data.isAvailableInTimeTrackingKioskMode = item.isAvailableInTimeTrackingKioskMode
    data.parentTaskID = item.parentTaskID
    data.preplanningBoardQuickSelect = item.preplanningBoardQuickSelect
    data.sort = item.sort
    data.task = item.task
    data.title = item.title
    data.wageType = item.wageType
    data.taskDescription = item.description
    data.workingTime = item.workingTime
    return data
}

func poToCDAdapter(data: CoreDataPO, context: NSManagedObjectContext) -> CDTask {
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
    return newData
}
