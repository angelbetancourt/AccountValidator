//
//  InMemoryAccountValidationStorage.swift
//  Account Validator
//
//  Created by Angel Betancourt on 15/05/21.
//

import Foundation

final class InMemoryAccountValidationStorage: AccountValidationStorage {

    static let shared = InMemoryAccountValidationStorage()

    private var registry = [AccountValidationAttempt]()
    private init() {}

    func save(validationAttempt: AccountValidationAttempt) {
        registry.append(validationAttempt)
    }

    func fetchAttempts() -> [AccountValidationAttempt] {
        registry
    }
}
