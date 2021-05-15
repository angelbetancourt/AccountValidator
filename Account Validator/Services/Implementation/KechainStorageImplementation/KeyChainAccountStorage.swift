//
//  KeyChainAccountStorage.swift
//  Account Validator
//
//  Created by Angel Betancourt on 15/05/21.
//

import Keychain_Storage

final class KeyChainAccountStorage: AccountStorage {

    private let server = "com.appgate"
    lazy var keyChainStorage = KeyChainStorage(server: server)

    func save(account: Account) {
        keyChainStorage.save(account: (username: account.username,
                                       password: account.password))

    }

    func fetch(username: Account.Username) -> Account? {
        guard let account = keyChainStorage.fetch(username: username) else {
            return nil
        }
        return .init(username: account.username, password: account.password)
    }
}
