//
//  TokenAPI.swift
//  vero-task-api
//
//  Created by Bertay Yönel on 31.12.2023.
//

import Foundation

protocol TokenFetchable {
    func fetchToken(request: TokenRequest, completion: @escaping (Result<TokenResponse, APIError>) -> Void)
}

final class TokenAPI: TokenFetchable {
    private let networkManager: Networking
    
    init(networkManager: Networking) {
        self.networkManager = networkManager
    }
    
    func fetchToken(request: TokenRequest, completion: @escaping (Result<TokenResponse, APIError>) -> Void) {
        networkManager.request(request: request, completion: completion)
    }
}
