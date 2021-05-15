//
//  ValidateAccountImpl.swift
//  Account Validator
//
//  Created by Angel Betancourt on 14/05/21.
//

import Foundation

fileprivate struct Validation {
    let account: Account
    let completion: ValidateAccountHandler
}

final class ValidateAccountImpl: ValidateAccount {
    
    private let dependencies: Dependencies

    struct Dependencies {
        let getCurrentDateService: GetCurrentDateService
        let getCurrentLocationService: GetCurrentLocationService
        let accountStorage: AccountStorage
        let accountValidationStorage: AccountValidationStorage
    }

    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }

    func execute(account: Account, completion: @escaping ValidateAccountHandler) {
        dependencies.getCurrentLocationService.getLocation { [weak self] result in
            self?.handle(currentLocationServiceResult: result, validation: .init(account: account, completion: completion))
        }
    }
}

private extension ValidateAccountImpl {
    func handle(currentLocationServiceResult: GetCurrentLocationServiceResult, validation: Validation) {
        switch currentLocationServiceResult {
        case .success(let location):
            dependencies.getCurrentDateService.getDate(deviceLocation: location) { [weak self] result in
                self?.handle(currentDateServiceResult: result, validation: validation)
            }
        case .failure(let error):
            validation.completion(.failure(.unableToGetCurrentLocation(reason: error.localizedDescription)))
        }
    }

    func handle(currentDateServiceResult: GetCurrentDateServiceResult, validation: Validation) {
        switch currentDateServiceResult {
        case .success(let currentDate):
            handle(receivedCurrentDate: currentDate, validation: validation)

        case .failure(let error):
            validation.completion(.failure(.unableToGetCurrentDate(reason: error.localizedDescription)))
        }
    }

    func handle(receivedCurrentDate: Date, validation: Validation) {
        guard let existingAcount = dependencies.accountStorage.fetch(username: validation.account.username) else {
            dependencies.accountValidationStorage.save(validationAttempt: .init(accountUsername: validation.account.username,
                                                                                date: receivedCurrentDate,
                                                                                result: .denied(reason: .accontDoesNotExist)))
            validation.completion(.failure(.accontDoesNotExist))
            return
        }

        if existingAcount == validation.account {
            dependencies.accountValidationStorage.save(validationAttempt: .init(accountUsername: validation.account.username,
                                                                                date: receivedCurrentDate,
                                                                                result: .approved))
            validation.completion(.success(()))
        } else {
            dependencies.accountValidationStorage.save(validationAttempt: .init(accountUsername: validation.account.username,
                                                                                date: receivedCurrentDate,
                                                                                result: .denied(reason: .invalidPassword)))
            validation.completion(.failure(.invalidPassword))
        }
    }
}
