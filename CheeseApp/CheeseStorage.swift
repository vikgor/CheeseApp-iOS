//
//  CheeseStorage.swift
//  CheeseApp
//
//  Created by Viktor Gordienko on 13.05.2022.
//

import Foundation

final class CheeseStorage: ObservableObject {
    @Published var items = CheeseStorage.initialItems

    static let initialItems: [CheeseModel] = []
}
