//
//  ResourceRequestError.swift
//  PlayingWithVapor-iOS
//
//  Created by Viktor Gordienko on 10.05.2022.
//

import Foundation

enum ResourceRequestError: Error {
  case noData
  case decodingError
  case encodingError
}
