//
//  ValidateAccountViewModel.swift
//  Account Validator
//
//  Created by Angel Betancourt on 15/05/21.
//

import Foundation

struct ButtonViewModel: Equatable {
    let title: String
    let isHidden: Bool
}

struct TextFieldViewModel: Equatable {
    let palceholder: String
}

struct ValidateAccountViewModel: Equatable {
    let showValidationAttemptsButton: ButtonViewModel
    let validateAccountButton: ButtonViewModel
    let createAccountButton: ButtonViewModel
    let usernameTextField: TextFieldViewModel
    let passwordTextField: TextFieldViewModel
    let passwordHint: String
}
