//
//  CreateCheeseData.swift
//  CheeseApp
//
//  Created by Viktor Gordienko on 12.05.2022.
//

import Foundation

struct CreateCheeseData: Codable {
    let name: String
    let country: String
    let type: String
    let animal: String
}

extension CheeseModel {
    func toCreateData() -> CreateCheeseData {
        .init(
            name: self.name,
            country: self.country,
            type: self.type,
            animal: self.animal
        )
    }
}
