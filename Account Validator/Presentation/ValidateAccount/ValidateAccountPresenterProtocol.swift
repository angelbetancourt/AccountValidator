//
//  ValidateAccountPresenterProtocol.swift
//  Account Validator
//
//  Created by Angel Betancourt on 15/05/21.
//

import Foundation

protocol ValidateAccountPresenterProtocol {
    func handleSceneDidLoad()
    func handleValidate(account: Account)
    func handleCreate(account: Account)
}

protocol ValidateAccountView: class {
    func display(viewModel: ValidateAccountViewModel)
    func display(validationAttemptsButton: ButtonViewModel)
    func display(alert: AlertViewModel)
    func display(activityIndicator: Bool)
}
