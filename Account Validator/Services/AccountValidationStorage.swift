//
//  AccountValidationStorage.swift
//  Account Validator
//
//  Created by Angel Betancourt on 15/05/21.
//

import Foundation

protocol AccountValidationStorage {
    func save(validationAttempt: AccountValidationAttempt)
    func fetchAttempts() -> [AccountValidationAttempt]
}
