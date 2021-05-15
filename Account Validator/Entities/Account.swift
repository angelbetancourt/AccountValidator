//
//  Account.swift
//  Account Validator
//
//  Created by Angel Betancourt on 14/05/21.
//

import Foundation

struct Account: Equatable {
    typealias Username = String
    let username: String
    let password: String
}

struct AccountValidationAttempt: Equatable {

    enum Result: Equatable {
        case approved
        case denied(reason: ValidateAccountError)
    }

    let accountUsername: Account.Username
    let date: Date
    let result: Result
}
