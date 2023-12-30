//
//  RequestModel.swift
//  vero-task-api
//
//  Created by Bertay Yönel on 30.12.2023.
//

import Foundation

class Request {
    // MARK: Properties
    var path: String {
        .empty
    }
    var parameters: [String: Any?] {
        [
            :
        ]
    }
    var headers: [String: String] {
        [
            :
        ]
    }
    var endpoint: String = .empty
}

// MARK: - Helpers
extension Request {
    
    /// Generates a request for the network call
    ///
    /// - Returns: A URL request to be used to make a network call.
    func generateRequest() -> URLRequest? {
        guard let url = generateURL(with: generateQueryItems()) else { return nil }
        var request = URLRequest(url: url)
        headers.forEach { header in
            request.addValue(header.value, forHTTPHeaderField: header.key)
        }
        return request
    }
}
private extension Request {
    // MARK: Private Functions
    func generateURL(with queryItems: [URLQueryItem]) -> URL? {
        let endpoint = endpoint.appending(path)
        var urlComponents = URLComponents(string: endpoint)
        urlComponents?.queryItems = queryItems
        guard let url = urlComponents?.url else { return nil }
        return url
    }
    /// Generates queries with the parameters
    /// found in the "parameters" array of the model.
    ///
    /// - Returns: An array created with the model's parameters
    func generateQueryItems() -> [URLQueryItem] {
        var queryItems: [URLQueryItem] = []
        parameters.forEach { parameter in
            let value = parameter.value as! String
            queryItems.append(.init(name: parameter.key, value: value))
        }
        return queryItems
    }
}
