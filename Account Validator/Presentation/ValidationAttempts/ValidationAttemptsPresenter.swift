//
//  ValidationAttemptsPresenter.swift
//  Account Validator
//
//  Created by Angel Betancourt on 15/05/21.
//

import Foundation

final class ValidationAttemptsPresenter {

    private weak var view: ValidationAttemptsView?

    private lazy var dateFormatter: DateFormatter = {
        let formater = DateFormatter()
        formater.dateStyle = .medium
        formater.timeStyle = .short
        return formater
    }()

    private let dependencies: Dependencies

    struct Dependencies {
        let accountValidationStorage: AccountValidationStorage
    }

    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }

    func set(view: ValidationAttemptsView) {
        self.view = view
    }
}

extension ValidationAttemptsPresenter: ValidationAttemptsPresenterProtocol {

    func handleSceneDidLoad() {
        let attempts = dependencies.accountValidationStorage.fetchAttempts()

        let validationAttempts = attempts.map { attempt -> ValidationAttemptViewModel in
            let username = attempt.accountUsername
            let title = "Validated Username: \(username)"
            let formattedDate = dateFormatter.string(from: attempt.date)
            let result = format(attemptResult: attempt.result)
            let subtitle = "\(formattedDate) - \(result)"
            return ValidationAttemptViewModel(title: title, subtitle: subtitle)
        }

        view?.display(validationAttempts: validationAttempts)
    }
}

private extension ValidationAttemptsPresenter {
    func format(attemptResult: AccountValidationAttempt.Result) -> String {
        switch attemptResult {
        case .approved:
            return "Approved"
        case .denied(let reason):
            return "Denied: \(reason)"
        }
    }
}
