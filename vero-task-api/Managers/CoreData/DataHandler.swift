//
//  DataHandler.swift
//  vero-task-api
//
//  Created by Bertay Yönel on 1.01.2024.
//

import Foundation
import Network

protocol DataHandable {
    func fetchAndUpdate(completion: @escaping ([CoreDataPO]) -> Void)
}

class DataHandler: DataHandable {
    
    private var coreDataManager = CoreDataManager.shared
    private var tokenAPI = DependencyContainer.shared.tokenAPI()
    private var taskAPI = DependencyContainer.shared.taskAPI()
    private let networkMonitor = NWPathMonitor()
    
    static let shared = DataHandler()
    private init() {
        
    }
    
    func fetchAndUpdate(completion: @escaping ([CoreDataPO]) -> Void) {
        if Reachability().isConnectedToNetwork() {
            let tokenRequest = TokenRequest()
            tokenAPI.fetchToken(request: tokenRequest) { [weak self] result in
                guard let self else { return }
                switch result {
                case .success(let success):
                    let taskRequest = TaskRequest(token: success.oauth.accessToken)
                    taskAPI.fetchTask(request: taskRequest) { [weak self] result in
                        guard let self else { return }
                        switch result {
                        case .success(let success):
                            writeToMemory(with: success)
                            var coreDataArray: [CoreDataPO] = []
                            success.forEach() { task in
                                let cd = generatePO(with: task)
                                coreDataArray.append(cd)
                            }
                            completion(coreDataArray)
                        case .failure(let failure):
                            ErrorHandler.shared.showError(message: failure.localizedDescription)
                        }
                    }
                case .failure(let failure):
                    ErrorHandler.shared.showError(message: failure.localizedDescription)
                }
            }
        } else {
            ErrorHandler.shared.showError(message: "No internet connection", duration: 1.6)
            completion(fetchFromMemory())
        }
    }
    
    func writeToMemory (with response: [TaskResponse]) {
        coreDataManager.deleteAll()
        response.forEach() { item in
            let data = generatePO(with: item)
            CoreDataManager.shared.write(data: data)
        }
    }

    func fetchFromMemory() -> [CoreDataPO] {
        var coreDataPO: [CoreDataPO] = []
        coreDataManager.fetch() { cdTask in
            cdTask?.forEach() { task in
                let coreData = cdToPoAdapter(task: task)
                coreDataPO.append(coreData)
            }
        }
        return coreDataPO
    }
}
