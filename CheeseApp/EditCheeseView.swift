//
//  EditCheeseView.swift
//  CheeseApp
//
//  Created by Viktor Gordienko on 13.05.2022.
//

import SwiftUI

struct EditCheeseView: View {
    @StateObject var cheese = CheeseObservableModel()
    @State private var showingAlert = false
    @State private var error: Error?
    @State private var presentingConfirmationDialog: Bool = false
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        EditCheeseList
            .navigationTitle(Constants.edit)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(Constants.save) { updateCheese() }
                    .disabled(cheese.name.isEmpty)
                }
            }
            .alert(isPresented: $showingAlert, content: { Alert.showAlert(error: error) })
            .confirmationDialog("", isPresented: $presentingConfirmationDialog) {
                Button(Constants.delete, role: .destructive) { deleteCheese() }
                Button(Constants.cancel, role: .cancel) { }
            }
    }

    var EditCheeseList: some View {
        List {
            CheeseParametersSection(cheese: cheese)
            Section(footer: Text(Constants.cheeseDescription)) { }
            CenteredHStack {
                Button(Constants.delete, role: .destructive) { presentingConfirmationDialog = true }
            }
        }
    }
}

private extension EditCheeseView {
    func updateCheese() {
        let cheese = CheeseModel(
            name: cheese.name,
            country: cheese.country,
            type: cheese.type,
            animal: cheese.animal
        )
        let cheeseUpdateData = cheese.toCreateData()
        guard let existingID = self.cheese.id else {
            showingAlert = true
            return
        }
        CheeseRequest(cheeseID: existingID).update(with: cheeseUpdateData) { result in
            switch result {
            case .success:
                // TODO: - dismiss on the main thread without the workaround
                DispatchQueue.main.async { dismiss() }
            case let .failure(error):
                self.error = error
                showingAlert.toggle()
            }
        }
    }

    func deleteCheese() {
        guard let existingID = self.cheese.id else {
            showingAlert = true
            return
        }
        CheeseRequest(cheeseID: existingID).delete()
        // TODO: - dismiss on the main thread without the workaround
        DispatchQueue.main.async { dismiss() }
    }
}
