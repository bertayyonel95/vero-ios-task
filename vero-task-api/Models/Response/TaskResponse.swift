//
//  ResponseModel.swift
//  vero-task-api
//
//  Created by Bertay Yönel on 30.12.2023.
//

import Foundation

struct TaskResponse: Decodable {
    let task: String
    let title: String
    let description: String
    let sort: String
    let wageType: String
    let businessUnitKey: String?
    let businessUnit: String
    let parentTaskID: String
    let preplanningBoardQuickSelect: String?
    let colorCode: String
    let workingTime: String?
    let isAvailableInTimeTrackingKioskMode: Bool
    
    enum CodingKeys: String, CodingKey {
        case task
        case title
        case description
        case sort
        case wageType
        case businessUnitKey = "BusinessUnitKey"
        case businessUnit
        case parentTaskID
        case preplanningBoardQuickSelect
        case colorCode
        case workingTime
        case isAvailableInTimeTrackingKioskMode
        
    }
}
