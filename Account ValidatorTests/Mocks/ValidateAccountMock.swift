//
//  ValidateAccountMock.swift
//  Account ValidatorTests
//
//  Created by Angel Betancourt on 15/05/21.
//

@testable import Account_Validator

final class ValidateAccountMock: ValidateAccount {
    var executeMock: ((Account, ValidateAccountHandler) -> Void)?

    func execute(account: Account, completion: @escaping ValidateAccountHandler) {
        executeMock?(account, completion)
    }
}
