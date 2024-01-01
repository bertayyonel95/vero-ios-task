//
//  NetworkManager.swift
//  vero-task-api
//
//  Created by Bertay Yönel on 30.12.2023.
//

import Foundation


import Foundation

protocol Networking {
    func request<T: Decodable>(request: Request, completion: @escaping (Result<T, APIError>) -> Void)
}

// MARK: - NetworkManager
class NetworkManager: Networking {
    // MARK: Properties
    private let session: URLSession
    // MARK: Init
    init(session: URLSession = .shared) {
        self.session = session
    }
    // MARK: Helpers
    /// Request data with the provided request mode from the database.
    ///
    /// - Parameters:
    ///    - request: request model to be used to make a network request.
    func request<T: Decodable>(request: Request, completion: @escaping (Result<T, APIError>) -> Void) {
        var generatedRequest: URLRequest?
        generatedRequest = request.generateRequest()
        LoadingManager.shared.show()
        let task = session.dataTask(with: generatedRequest!) { data, response, error in
            LoadingManager.shared.hide()
            if let error {
                completion(.failure(.unknownError))
                return
            }
            guard let data else {
                completion(.failure(.unknownError))
                return
            }
            do {
                let convertedData = try JSONDecoder().decode(T.self, from: data)
                completion(.success(convertedData))
            } catch {
                completion(.failure(.unknownError))
            }
        }
        task.resume()
    }
}
