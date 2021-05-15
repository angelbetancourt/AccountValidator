//
//  CreateAccount.swift
//  Account Validator
//
//  Created by Angel Betancourt on 14/05/21.
//

import Foundation

enum CreateAccountError: Error, Equatable {
    case invalidUsername
    case invalidPassword
}

typealias CreateAccountResult = Result<Void, CreateAccountError>

protocol CreateAccount {
    func execute(account: Account) -> CreateAccountResult
}
