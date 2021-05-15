//
//  KeychainStorage.swift
//  Keychain Storage
//
//  Created by Angel Betancourt on 15/05/21.
//

import Foundation

public final class KeyChainStorage {

    private let server: String

    public init(server: String) {
        self.server = server
    }
    
    public func save(account: Account) {
        let username = account.username
        guard let password = account.password.data(using: .utf8) else {
            return
        }

        if let _ = fetch(username: username) {
            update(account: account)
        } else {
            let query = [kSecClass: kSecClassInternetPassword,
                         kSecAttrAccount: username,
                         kSecAttrServer: server,
                         kSecValueData: password] as CFDictionary

            _ = SecItemAdd(query as CFDictionary, nil)
        }


    }

    public func fetch(username: Username) -> Account? {
        let query = [kSecClass: kSecClassInternetPassword,
                     kSecAttrServer: server,
                     kSecAttrAccount: username,
                     kSecReturnAttributes: true,
                     kSecReturnData: true] as CFDictionary

        var result: AnyObject?
        let status = SecItemCopyMatching(query, &result)

        print("Operation finished with status: \(status)")
        guard let dic = result as? NSDictionary else {
            return nil
        }

        guard let username = dic[kSecAttrAccount] as? String,
              let passwordData = dic[kSecValueData] as? Data,
              let password = String(data: passwordData, encoding: .utf8) else {

            return nil
        }

        return (username: username, password: password)
    }

    private func update(account: Account) {
        guard let password = account.password.data(using: .utf8) else {
            return
        }

        let query = [kSecClass: kSecClassInternetPassword,
                     kSecAttrAccount: account.username,
                     kSecAttrServer: server] as CFDictionary

        let updateFields = [kSecValueData: password] as CFDictionary
        _ = SecItemUpdate(query, updateFields)
    }
}

