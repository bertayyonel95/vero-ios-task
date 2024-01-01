//
//  HelperFunctions.swift
//  vero-task-api
//
//  Created by Bertay Yönel on 1.01.2024.
//

import Foundation

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
