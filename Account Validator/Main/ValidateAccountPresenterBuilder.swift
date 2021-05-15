//
//  ValidateAccountPresenterBuilder.swift
//  Account Validator
//
//  Created by Angel Betancourt on 14/05/21.
//

import Foundation

struct ValidateAccountPresenterBuilder {
    static func build(view: ValidateAccountView) -> ValidateAccountPresenterProtocol {
        let getCurrentDateService = GetCurrentDateGeoNamesService()
        let getCurrentLocationService = GetCurrentLocationCoreLocationService()
        let accountStorage = KeyChainAccountStorage()
        let accountValidationStorage = InMemoryAccountValidationStorage.shared
        let createAccount = CreateAccountImpl(dependencies: .init(accountStorage: accountStorage))
        let validateAccount = ValidateAccountImpl(dependencies: .init(getCurrentDateService: getCurrentDateService,
                                                                    getCurrentLocationService: getCurrentLocationService,
                                                                    accountStorage: accountStorage,
                                                                    accountValidationStorage: accountValidationStorage))
        
        let presenter = ValidateAccountPresenter(dependencies: .init(validateAccount: validateAccount,
                                                                     createAccount: createAccount,
                                                                     accountStorage: accountStorage))
        presenter.set(view: view)
        return presenter
    }
}

struct ValidationAttemptsPresenterBuilder {
    static func build(view: ValidationAttemptsView) -> ValidationAttemptsPresenterProtocol {
        let accountValidationStorage = InMemoryAccountValidationStorage.shared
        let presenter = ValidationAttemptsPresenter(dependencies: .init(accountValidationStorage: accountValidationStorage))
        presenter.set(view: view)
        return presenter
    }
}
