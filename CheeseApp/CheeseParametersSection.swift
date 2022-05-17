//
//  CheeseParametersSection.swift
//  CheeseApp
//
//  Created by Viktor Gordienko on 16.05.2022.
//

import SwiftUI

struct CheeseParametersSection: View {
    @StateObject var cheese = CheeseObservableModel()

    var body: some View {
        Section {
            TextField(Constants.name, text: $cheese.name)
            TextField(Constants.country, text: $cheese.country)
            TextField(Constants.cheeseType, text: $cheese.type)
            TextField(Constants.animal, text: $cheese.animal)
        }
    }
}
