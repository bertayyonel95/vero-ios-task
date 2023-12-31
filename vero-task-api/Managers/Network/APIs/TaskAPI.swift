//
//  TaskAPI.swift
//  vero-task-api
//
//  Created by Bertay Yönel on 31.12.2023.
//

import Foundation

protocol TaskFetchable {
    func fetchTask(request: TaskRequest, completion: @escaping (Result<[TaskResponse], APIError>) -> Void)
}

final class TaskAPI: TaskFetchable {
    private let networkManager: Networking
    
    init(networkManager: Networking) {
        self.networkManager = networkManager
    }
    
    func fetchTask(request: TaskRequest, completion: @escaping (Result<[TaskResponse], APIError>) -> Void) {
        networkManager.request(request: request, completion: completion)
    }
}
