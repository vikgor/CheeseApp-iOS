//
//  Alert+Helpers.swift
//  CheeseApp
//
//  Created by Viktor Gordienko on 13.05.2022.
//

import SwiftUI

extension Alert {
    static func showAlert(title: String? = nil, error: Error?) -> Alert {
        guard let title = title else {
            return Alert(
                title: Text(Constants.error),
                message: Text(error?.decoded() ?? ""),
                dismissButton: .cancel()
            )
        }
        return Alert(
            title: Text(title),
            dismissButton: .default(Text(Constants.ok))
        )
    }
}
