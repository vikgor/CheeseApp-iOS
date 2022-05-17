//
//  CheeseModel.swift
//  CheeseApp
//
//  Created by Viktor Gordienko on 12.05.2022.
//

import Foundation

final class CheeseModel: Codable {
    var id: UUID?
    var name: String
    var country: String
    var type: String
    var animal: String

    init(
        name: String,
        country: String = "",
        type: String = "",
        animal: String = ""
    ) {
        self.name = name
        self.country = country
        self.type = type
        self.animal = animal
    }
}
