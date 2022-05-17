//
//  ResourceRequest.swift
//  PlayingWithVapor-iOS
//
//  Created by Viktor Gordienko on 10.05.2022.
//

import Foundation

struct ResourceRequest<ResourceType> where ResourceType: Codable {
    let baseURL = "http://localhost:8080/api/"
    let resourceURL: URL

    init(resourcePath: String) {
        guard let resourceURL = URL(string: baseURL) else {
            fatalError("Failed to convert baseURL to a URL")
        }
        self.resourceURL = resourceURL.appendingPathComponent(resourcePath)
    }

    func getAll(completion: @escaping (Result<[ResourceType], CustomError.ResourceRequest>) -> Void) {
        let dataTask = URLSession.shared.dataTask(with: resourceURL) { data, _, error in
            if let error = error {
                completion(.failure(.custom(error)))
                return
            }
            guard let jsonData = data else {
                completion(.failure(.noData))
                return
            }
            do {
                let resources = try JSONDecoder().decode([ResourceType].self, from: jsonData)
                completion(.success(resources))
            } catch {
                completion(.failure(.decodingError))
            }
        }
        dataTask.resume()
    }

    func save<CreateType>(
        _ saveData: CreateType,
        completion: @escaping (Result<ResourceType, CustomError.ResourceRequest>) -> Void
    ) where CreateType: Codable {
        do {
            var urlRequest = URLRequest(url: resourceURL)
            urlRequest.httpMethod = "POST"
            urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
            urlRequest.httpBody = try JSONEncoder().encode(saveData)
            let dataTask = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
                if let error = error {
                    completion(.failure(.custom(error)))
                    return
                }
                guard
                    let httpResponse = response as? HTTPURLResponse,
                    httpResponse.statusCode == 200,
                    let jsonData = data
                else {
                    completion(.failure(.noData))
                    return
                }

                do {
                    let resource = try JSONDecoder().decode(ResourceType.self, from: jsonData)
                    completion(.success(resource))
                } catch {
                    completion(.failure(.decodingError))
                }
            }
            dataTask.resume()
        } catch {
            completion(.failure(.encodingError))
        }
    }

    func get(completion: @escaping (Result<ResourceType, CustomError.ResourceRequest>) -> Void) {
        let dataTask = URLSession.shared.dataTask(with: resourceURL) { data, _, error in
            if let error = error {
                completion(.failure(.custom(error)))
                return
            }
            guard let jsonData = data else {
                completion(.failure(.noData))
                return
            }
            do {
                let resource = try JSONDecoder().decode(ResourceType.self, from: jsonData)
                completion(.success(resource))
            } catch {
                completion(.failure(.decodingError))
            }
        }
        dataTask.resume()
    }
}
