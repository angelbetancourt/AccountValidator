//
//  AccountStorageMock.swift
//  Account ValidatorTests
//
//  Created by Angel Betancourt on 15/05/21.
//

@testable import Account_Validator

final class AccountStorageMock: AccountStorage {
    var saveMocck: ((Account) -> Void)?
    var fetchMock: ((Account.Username) -> Account?)?

    func save(account: Account) {
        saveMocck?(account)
    }

    func fetch(username: Account.Username) -> Account? {
        return fetchMock?(username)
    }
}
