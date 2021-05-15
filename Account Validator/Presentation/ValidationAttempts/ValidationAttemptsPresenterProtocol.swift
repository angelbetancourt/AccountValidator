//
//  ValidationAttemptsPresenterProtocol.swift
//  Account Validator
//
//  Created by Angel Betancourt on 15/05/21.
//

import Foundation

protocol ValidationAttemptsPresenterProtocol {
    func handleSceneDidLoad()
}

protocol ValidationAttemptsView: class {
    func display(validationAttempts: [ValidationAttemptViewModel])
}
