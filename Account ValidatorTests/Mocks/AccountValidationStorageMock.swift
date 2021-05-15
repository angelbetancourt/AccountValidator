//
//  AccountValidationStorageMock.swift
//  Account ValidatorTests
//
//  Created by Angel Betancourt on 15/05/21.
//

@testable import Account_Validator

final class AccountValidationStorageMock: AccountValidationStorage {

    var receivedValidationAttempts = [AccountValidationAttempt]()

    var saveMock: ((AccountValidationAttempt) -> Void)?
    var fetchMock: (() -> [AccountValidationAttempt])?

    func save(validationAttempt: AccountValidationAttempt) {
        saveMock?(validationAttempt)
        receivedValidationAttempts.append(validationAttempt)
    }

    func fetchAttempts() -> [AccountValidationAttempt] {
        return fetchMock?() ?? []
    }
}
