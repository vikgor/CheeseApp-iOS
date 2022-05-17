//
//  CheeseRequest.swift
//  PlayingWithVapor-iOS
//
//  Created by Viktor Gordienko on 10.05.2022.
//

import Foundation

struct CheeseRequest {
    let resource: URL

    init(cheeseID: UUID) {
        let resourceString = "http://localhost:8080/api/cheeses/\(cheeseID)"
        guard let resourceURL = URL(string: resourceString) else {
            fatalError("Unable to create URL")
        }
        self.resource = resourceURL
    }

    func update(
        with updateData: CreateCheeseData,
        completion: @escaping (Result<CheeseModel, CustomError.ResourceRequest>) -> Void
    ) {
        do {
            var urlRequest = URLRequest(url: resource)
            urlRequest.httpMethod = "PUT"
            urlRequest.httpBody = try JSONEncoder().encode(updateData)
            urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
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
                    let cheese = try JSONDecoder().decode(CheeseModel.self, from: jsonData)
                    completion(.success(cheese))
                } catch {
                    completion(.failure(.decodingError))
                }
            }
            dataTask.resume()
        } catch {
            completion(.failure(.encodingError))
        }
    }

    func delete() {
        var urlRequest = URLRequest(url: resource)
        urlRequest.httpMethod = "DELETE"
        let dataTask = URLSession.shared.dataTask(with: urlRequest)
        dataTask.resume()
    }

    func add(completion: @escaping (Result<Void, CustomError.Add>) -> Void) {
        let url = resource
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        let dataTask = URLSession.shared.dataTask(with: urlRequest) { _, response, error in
            if let error = error {
                completion(.failure(.custom(error)))
                return
            }
            guard
                let httpResponse = response as? HTTPURLResponse,
                httpResponse.statusCode == 201
            else {
                completion(.failure(.invalidResponse))
                return
            }
            completion(.success(()))
        }
        dataTask.resume()
    }

}
