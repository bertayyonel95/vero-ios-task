//
//  CoreDataPO.swift
//  vero-task-api
//
//  Created by Bertay Yönel on 1.01.2024.
//

import Foundation
import CoreData

class CoreDataPO {
    var task: String = .empty
    var title: String = .empty
    var taskDescription: String = .empty
    var sort: String = .empty
    var wageType: String = .empty
    var businessUnitKey: String? = .empty
    var businessUnit: String = .empty
    var parentTaskID: String = .empty
    var preplanningBoardQuickSelect: String? = .empty
    var colorCode: String = .empty
    var workingTime: String? = .empty
    var isAvailableInTimeTrackingKioskMode: Bool = true

}
