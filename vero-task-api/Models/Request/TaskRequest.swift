//
//  TaskRequest.swift
//  vero-task-api
//
//  Created by Bertay Yönel on 31.12.2023.
//

import Foundation

final class TaskRequest: Request {
    
    private var loginToken: String
    
    override var headers: [String : String] {
        let headers: [String: String] = [ "Authorization: ": "Bearer \(loginToken)" ]
        return headers
    }
    
    init(token: String) {
        loginToken = token
        super.init(endpoint: Constant.API.resourceUrl, method: .get, body: nil)
    }
}
