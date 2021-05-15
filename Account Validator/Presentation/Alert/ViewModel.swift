//
//  ViewModel.swift
//  Account Validator
//
//  Created by Angel Betancourt on 14/05/21.
//

import Foundation

struct AlertViewModel: Equatable {
    struct Action {
        let title: String
        let handler: () -> ()
    }
    let title: String
    let message: String
    let action: Action
}

extension AlertViewModel.Action: Equatable {
    static func == (lhs: AlertViewModel.Action, rhs: AlertViewModel.Action) -> Bool {
        lhs.title == rhs.title
    }
}
