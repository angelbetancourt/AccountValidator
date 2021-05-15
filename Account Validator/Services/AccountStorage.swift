//
//  Storage.swift
//  Account Validator
//
//  Created by Angel Betancourt on 14/05/21.
//

import Foundation

typealias AccountFetchResult = Result<Account, AccountFetchError>

enum AccountFetchError: Error {
    case accountDoesNotExist
    case unableToParseSttoredAccount
}

protocol AccountStorage {
    func save(account: Account)
    func fetch(username: Account.Username) -> Account?
}




