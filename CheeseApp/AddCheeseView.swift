//
//  AddCheeseView.swift
//  CheeseApp
//
//  Created by Viktor Gordienko on 13.05.2022.
//

import SwiftUI

struct AddCheeseView: View {
    @StateObject var cheese = CheeseObservableModel()
    @State private var showingAlert = false
    @State private var error: Error?
    @Environment(\.dismiss) private var dismiss
    let onSaveAction: () -> ()

    var body: some View {
        NavigationView {
            EditCheeseList
                .navigationTitle(Constants.add)
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button(Constants.cancel) { dismiss() }
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(Constants.save) { saveCheese() }
                        .disabled(cheese.name.isEmpty)
                    }
                }
                .alert(isPresented: $showingAlert, content: { Alert.showAlert(error: error) })
        }
    }


    var EditCheeseList: some View {
        List {
            CheeseParametersSection(cheese: cheese)
            Section(footer: Text(Constants.cheeseDescription)) { }
        }
    }
}

private extension AddCheeseView {
    func saveCheese() {
        let cheese = CheeseModel(
            name: cheese.name,
            country: cheese.country,
            type: cheese.type,
            animal: cheese.animal
        )
        let cheeseSaveData = cheese.toCreateData()
        ResourceRequest<CheeseModel>(resourcePath: "cheeses").save(cheeseSaveData) { result in
            switch result {
            case .success:
                dismiss()
                onSaveAction()
            case let .failure(error):
                self.error = error
                showingAlert.toggle()
            }
        }
    }
}
