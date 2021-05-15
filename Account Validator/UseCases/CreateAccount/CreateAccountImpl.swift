//
//  CreateAccountImpl.swift
//  Account Validator
//
//  Created by Angel Betancourt on 14/05/21.
//

import Foundation

struct CreateAccountImpl: CreateAccount {

    private static let passwordPattern =
        // At least 8 characters
        #"(?=.{8,})"# +

        // At least one uppercase letter
        #"(?=.*[A-Z])"# +

        // At least one lowercase letter
        #"(?=.*[a-z])"# +

        // At least one number
        #"(?=.*\d)"# +

        // At least one special character
        #"(?=.*[ !$%&?._-])"#

    private static let emailPattern = #"^\S+@\S+\.\S+$"#


    private let dependencies: Dependencies

    struct Dependencies {
        let accountStorage: AccountStorage
    }

    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }

    func execute(account: Account) -> CreateAccountResult {
        guard let validUsername = isValid(account.username, using: Self.emailPattern) else {
            return .failure(.invalidUsername)
        }

        guard let validPassword = isValid(account.password, using: Self.passwordPattern) else {
            return .failure(.invalidPassword)
        }

        let account = Account(username: validUsername, password: validPassword)
        dependencies.accountStorage.save(account: account)
        return .success(())
    }
}

private extension CreateAccountImpl {
    func isValid(_ field: String, using validationPattern: String) -> String? {
        guard !field.isEmpty else {
            return nil
        }

        let result = field.range(of: validationPattern,
                                 options: .regularExpression)

        return (result == nil) ? nil : field
    }
}
