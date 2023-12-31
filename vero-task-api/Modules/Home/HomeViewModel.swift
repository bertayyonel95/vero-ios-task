//
//  HomeViewModel.swift
//  vero-task-api
//
//  Created by Bertay Yönel on 30.12.2023.
//

import Foundation

// MARK: - HomeViewModelInput
protocol HomeViewModelInput {
    // MARK: Properties
    var output: HomeViewModelOutput? { get set }
}

// MARK: - HomeViewModelOutput
protocol HomeViewModelOutput: AnyObject {
    
}

// MARK: - HomeViewModel
final class HomeViewModel: HomeViewModelInput  {
    //MARK: Properties
    private var homeRouter: HomeRouting
    private var tokenAPI: TokenFetchable
    private var taskAPI: TaskFetchable
    private var token: String = .empty
    weak var output: HomeViewModelOutput?
    
    init(homeRouter: HomeRouting, tokenAPI: TokenFetchable, taskAPI: TaskFetchable) {
        self.homeRouter = homeRouter
        self.tokenAPI = tokenAPI
        self.taskAPI = taskAPI
        getToken()
    }
    
    func getToken() {
        let tokenRequest = TokenRequest()
        tokenAPI.fetchToken(request: tokenRequest) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let success):
                token = success.oauth.accessToken
                getTaskList()
            case .failure(let failure):
                print(failure)
            }
        }
    }
    
    func getTaskList() {
        let taskRequest = TaskRequest(token: token)
        taskAPI.fetchTask(request: taskRequest) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let success):
                print(success)
            case .failure(let failure):
                print(failure)
            }
        }
    }
}
