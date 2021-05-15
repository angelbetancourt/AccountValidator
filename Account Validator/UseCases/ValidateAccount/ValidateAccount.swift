//
//  ValidateAccount.swift
//  Account Validator
//
//  Created by Angel Betancourt on 14/05/21.
//

import Foundation

enum ValidateAccountError: Error, Equatable {
    case unableToGetCurrentLocation(reason: String)
    case unableToGetCurrentDate(reason: String)
    case accontDoesNotExist
    case invalidPassword
}

typealias ValidateAccountResult = Result<Void, ValidateAccountError>
typealias ValidateAccountHandler = (ValidateAccountResult) -> Void

protocol ValidateAccount {
    func execute(account: Account, completion: @escaping ValidateAccountHandler)
}
