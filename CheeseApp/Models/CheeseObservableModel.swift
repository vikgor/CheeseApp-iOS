//
//  CheeseObservableModel.swift
//  CheeseApp
//
//  Created by Viktor Gordienko on 16.05.2022.
//

import SwiftUI

class CheeseObservableModel: ObservableObject {
    @Published var id: UUID?
    @Published var name = ""
    @Published var country = ""
    @Published var type: String = ""
    @Published var animal: String = ""

    init(
        id: UUID? = nil,
        name: String = "",
        country: String = "",
        type: String = "",
        animal: String = ""
    ) {
        self.id = id
        self.name = name
        self.country = country
        self.type = type
        self.animal = animal
    }
}
