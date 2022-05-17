//
//  CustomError.swift
//  PlayingWithVapor-iOS
//
//  Created by Viktor Gordienko on 10.05.2022.
//

import Foundation

enum CustomError { }

extension CustomError {
    enum ResourceRequest: Error {
        case noData
        case decodingError
        case encodingError
        case custom(Error)
    }
}

extension CustomError {
    enum Add: Error {
        case noID
        case invalidResponse
        case custom(Error)
    }
}

extension Error {
    func decoded() -> String {
        guard let error = self as? CustomError.ResourceRequest else {
            return localizedDescription
        }
        switch error {
        case .noData:
            return "No data"
        case .decodingError:
            return "Decoding error"
        case .encodingError:
            return "Encoding error"
        case let .custom(error):
            return error.localizedDescription
        }
    }
}
