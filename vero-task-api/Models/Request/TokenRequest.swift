//
//  TokenRequest.swift
//  vero-task-api
//
//  Created by Bertay Yönel on 31.12.2023.
//

import Foundation

final class TokenRequest: Request {
    
    init() {
        var body = try? JSONSerialization.data(withJSONObject: [
            "username": Constant.API.username,
            "password": Constant.API.password
        ], options: [])
        super.init(endpoint: Constant.API.tokenUrl, method: .post, body: body)
    }
    
    override var parameters: [String : Any?] {
        var parameters = super.parameters
        parameters["username"] = Constant.API.username
        parameters["password"] = Constant.API.password
        return parameters
    }
    
    override var headers: [String : String] {
        let headers: [String : String] = [
            "Authorization" : "Basic " + Constant.API.loginToken,
            "Content-Type" : "application/json"
        ]
        return headers
    }
}
