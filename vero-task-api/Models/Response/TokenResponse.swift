//
//  TokenResponseü.swift
//  vero-task-api
//
//  Created by Bertay Yönel on 30.12.2023.
//

import Foundation

struct OAuth: Decodable {
    let accessToken: String
    let expiration: Int
    let tokenType: String
    let scope: String?
    let refreshToken: String
    
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case expiration = "expires_in"
        case tokenType = "token_type"
        case scope
        case refreshToken = "refresh_token"
    }
}

struct UserInfo: Decodable {
    let personalNo: Int
    let firstName: String
    let lastName: String
    let displayName: String
    let active: Bool
    let businessUnit: String
    
    enum CodingKeys: String, CodingKey {
        case personalNo
        case firstName
        case lastName
        case displayName
        case active
        case businessUnit
    }
}

struct TokenResponse: Decodable {
    let oauth: OAuth
    let userInfo: UserInfo
    let permissions: [String?]
    let apiVersion: String
    let showPasswordPrompt: Bool
}
