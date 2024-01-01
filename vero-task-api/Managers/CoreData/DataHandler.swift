//
//  DataHandler.swift
//  vero-task-api
//
//  Created by Bertay Yönel on 1.01.2024.
//

import Foundation
import Network

protocol DataHandable {
    func fetchFromMemory() -> [CoreDataPO]
    func reloadToMemory()
}

class DataHandler: DataHandable {
    
    private var coreDataManager = CoreDataManager.shared
    private var tokenAPI = DependencyContainer.shared.tokenAPI()
    private var taskAPI = DependencyContainer.shared.taskAPI()
    private let networkMonitor = NWPathMonitor()
    
    static let shared = DataHandler()
    private init() {
        
    }
    
    func reloadToMemory() {
        if Reachability().isConnectedToNetwork(){
            getToken()
        } else {
            print("no internet")
        }
    }
    
    func fetchFromMemory() -> [CoreDataPO] {
        var coreDataPO: [CoreDataPO] = []
        coreDataManager.fetch() { cdTask in
            cdTask?.forEach() { task in
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
                coreDataPO.append(coreData)
            }
        }
        return coreDataPO
    }
    
    func fetchToMemory(with response: [TaskResponse]) {
        coreDataManager.deleteAll()
        response.forEach() { item in
            let data = generatePO(with: item)
            CoreDataManager.shared.write(data: data)
        }
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
    
    func getToken() {
        let tokenRequest = TokenRequest()
        tokenAPI.fetchToken(request: tokenRequest) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let success):
                getTaskList(with: success.oauth.accessToken)
            case .failure(let failure):
                print(failure)
            }
        }
    }
    
    func getTaskList(with token: String) {
        let taskRequest = TaskRequest(token: token)
        taskAPI.fetchTask(request: taskRequest) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let success):
                fetchToMemory(with: success)
            case .failure(let failure):
                print(failure)
            }
        }
    }
}

extension DataHandler {
    
}
