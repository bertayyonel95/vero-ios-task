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
    let colorCode: String
    
    enum CodingKeys: String, CodingKey {
        case task
        case title
        case description
        case colorCode
    }
}
