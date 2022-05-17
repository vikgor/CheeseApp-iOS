//
//  ContentView.swift
//  CheeseApp
//
//  Created by Viktor Gordienko on 12.05.2022.
//

import SwiftUI

struct ContentView: View {
    @State private var cheeseList: [CheeseModel] = []
    @State private var error: Error?
    @State private var showingAlert = false
    @State private var randomCheeseName: String?
    @State private var showingEditingModalSheet = false

    var body: some View {
        NavigationView {
            List {
                if cheeseList.isEmpty {
                    Text(Constants.cheesesListEmptyDescription)
                } else {
                    Section(header: Text(Constants.cheesesList)) {
                        ForEach(cheeseList, id: \.id) { cheese in
                            NavigationLink(destination: EditCheeseView(
                                cheese: CheeseObservableModel(
                                    id: cheese.id,
                                    name: cheese.name,
                                    country: cheese.country,
                                    type: cheese.type,
                                    animal: cheese.animal
                                )
                            )) {
                                VStack(alignment: .leading) {
                                    Text(cheese.name).font(.headline)
                                    Text(cheese.country)
                                }
                            }
                        }
                        .onDelete { deleteCheese(at: $0) }
                    }
                }
                Section {
                    CenteredHStack {
                        Button(Constants.findRandomCheese) { findRandomCheese() }
                    }
                }
            }
            .onAppear(perform: { getAllCheeses() })
            .refreshable { getAllCheeses() }
            .navigationTitle(Constants.cheeseApp)
            .alert(isPresented: $showingAlert, content: {
                Alert.showAlert(title: randomCheeseName, error: error) })
            .toolbar {
                Button(Constants.add) { self.showingEditingModalSheet = true }
            }
            .sheet(
                isPresented: $showingEditingModalSheet,
                content: {
                    AddCheeseView(cheese: CheeseObservableModel(), onSaveAction: getAllCheeses)
                })
        }
    }
}

private extension ContentView {
    func getAllCheeses() {
        let request = ResourceRequest<CheeseModel>(resourcePath: "cheeses")
        request.getAll { result in
            switch result {
            case let .failure(error):
                self.error = error
                showingAlert.toggle()
            case let .success(cheeses):
                self.cheeseList = cheeses
            }
        }
    }

    func deleteCheese(at offsets: IndexSet) {
        let cheeseToDelete = offsets.map { self.cheeseList[$0].id }
        _ = cheeseToDelete.compactMap({ id in
            guard let id = id else { return }
            CheeseRequest(cheeseID: id).delete()
            cheeseList.removeAll() { $0.id == id }
        })
    }

    func findRandomCheese() {
        let request = ResourceRequest<CheeseModel>(resourcePath: "cheeses/random")
        request.get { result in
            switch result {
            case let .failure(error):
                self.error = error
                showingAlert.toggle()
            case let .success(randomCheese):
                self.randomCheeseName = randomCheese.name
                showingAlert.toggle()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
