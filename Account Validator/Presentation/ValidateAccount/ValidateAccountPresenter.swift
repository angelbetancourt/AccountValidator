//
//  ValidateAccountPresenter.swift
//  Account Validator
//
//  Created by Angel Betancourt on 14/05/21.
//

import Foundation

// Strings are raw, in real app bette ruse a string provider, and add localization files for them

final class ValidateAccountPresenter {

    private weak var view: ValidateAccountView?

    private let dependencies: Dependencies

    struct Dependencies {
        let validateAccount: ValidateAccount
        let createAccount: CreateAccount
        let accountStorage: AccountStorage
    }

    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }

    func set(view: ValidateAccountView) {
        self.view = view
    }
}

extension ValidateAccountPresenter: ValidateAccountPresenterProtocol {
    
    func handleSceneDidLoad() {
        view?.display(viewModel: .init(showValidationAttemptsButton: .init(title: "Validation Attempts", isHidden: true),
                                       validateAccountButton: .init(title: "Validate Account", isHidden: false),
                                       createAccountButton: .init(title: "Create Account", isHidden: false),
                                       usernameTextField: .init(palceholder: "Username"),
                                       passwordTextField: .init(palceholder: "Password"),
                                       passwordHint: "At least 8 characters\nAt least: an uppercased character, a lowercased character, a number, an special character\n"))
    }

    func handleValidate(account: Account) {
        view?.display(activityIndicator: true)
        dependencies.validateAccount.execute(account: account) { [weak self] result in
            self?.view?.display(activityIndicator: false)
            self?.handle(result: result)
        }
    }

    func handleCreate(account: Account) {
        let result = dependencies.createAccount.execute(account: account)
        handle(result: result)
    }
}

private extension ValidateAccountPresenter {

    func setValidationAttemptsButton(disabled: Bool) {
        view?.display(validationAttemptsButton: .init(title: "Validation Attempts", isHidden: disabled))
    }

    func handle(result: ValidateAccountResult) {
        switch result {
        case .success:
            view?.display(alert: .init(title: "Account is Valid",
                                       message: "The account has been validated successfully",
                                       action: .init(title: "Ok", handler: { })))
            setValidationAttemptsButton(disabled: false)


        case .failure(let error):
            view?.display(alert: format(error: error))
            setValidationAttemptsButton(disabled: true)

        }
    }

    func handle(result: CreateAccountResult) {
        switch result {
        case .success:
            view?.display(alert: .init(title: "Account Created",
                                       message: "The account has been successfully created and stored",
                                       action: .init(title: "Ok", handler: { })))
        case .failure(let error):
            view?.display(alert: format(error: error))

        }
    }

    func format(error: CreateAccountError) -> AlertViewModel {
        switch error {
        case .invalidPassword:
            return .init(title: "Invalid Password",
                         message: "Make sure it satisfy rules",
                         action: .init(title: "Ok", handler: { }))

        case .invalidUsername:
            return .init(title: "Invalid username",
                         message: "Make sure it is a valid email address",
                         action: .init(title: "Ok", handler: { }))
        }
    }

    func format(error: ValidateAccountError) -> AlertViewModel {
        switch error {
        case .unableToGetCurrentDate(let reason):
            return .init(title: "Couldn't get the current Date",
                         message: reason,
                         action: .init(title: "Ok", handler: { }))

        case .unableToGetCurrentLocation(let reason):
            return .init(title: "Couldn't get your location",
                         message: reason,
                         action: .init(title: "Ok", handler: { }))

        case .accontDoesNotExist:
            return .init(title: "Account Does Not Exist",
                         message: "Make sure the usermane is right",
                         action: .init(title: "Ok", handler: { }))

        case .invalidPassword:
            return .init(title: "Invalid Password",
                         message: "Make sure the password is right",
                         action: .init(title: "Ok", handler: { }))
        }
    }
}
