//
//  CenteredHStack.swift
//  CheeseApp
//
//  Created by Viktor Gordienko on 15.05.2022.
//

import SwiftUI

struct CenteredHStack<Content: View>: View {
    var content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        HStack {
            Spacer()
            content
            Spacer()
        }
    }
}
