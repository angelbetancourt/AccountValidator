//
//  ValidateAccountViewSpy.swift
//  Account Validator
//
//  Created by Angel Betancourt on 15/05/21.
//

@testable import Account_Validator

final class ValidateAccountViewSpy: ValidateAccountView {

    enum Call: Equatable {
        case displayViewModel(ValidateAccountViewModel)
        case displayValidationAttemptsButton(ButtonViewModel)
        case displayAlert(AlertViewModel)
        case displayaActivityIndicator(Bool)
    }

    var receivedCalls = [Call]()

    func display(viewModel: ValidateAccountViewModel) {
        receivedCalls.append(.displayViewModel(viewModel))
    }

    func display(validationAttemptsButton: ButtonViewModel) {
        receivedCalls.append(.displayValidationAttemptsButton(validationAttemptsButton))
    }

    func display(alert: AlertViewModel) {
        receivedCalls.append(.displayAlert(alert))
    }

    func display(activityIndicator: Bool) {
        receivedCalls.append(.displayaActivityIndicator(activityIndicator))
    }
}
