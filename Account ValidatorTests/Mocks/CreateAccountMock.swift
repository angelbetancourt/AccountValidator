//
//  CreateAccountMock.swift
//  Account ValidatorTests
//
//  Created by Angel Betancourt on 15/05/21.
//

@testable import Account_Validator

final class CreateAccountMock: CreateAccount {
    var executeMock: ((Account) -> CreateAccountResult)?

    func execute(account: Account) -> CreateAccountResult {
        return executeMock?(account) ?? .success(())
    }
}
