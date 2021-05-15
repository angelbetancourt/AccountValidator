//
//  ValidateAccountPresenterTests.swift
//  Account ValidatorTests
//
//  Created by Angel Betancourt on 15/05/21.
//

import XCTest
@testable import Account_Validator

final class ValidateAccountPresenterTests: XCTestCase {

    var sut: ValidateAccountPresenter!

    var validateAccount: ValidateAccountMock!
    var createAccount: CreateAccountMock!
    var accountStorage: AccountStorageMock!

    override func setUp() {
        super.setUp()
        validateAccount = .init()
        createAccount = .init()
        accountStorage = .init()

        sut = .init(dependencies: .init(validateAccount: validateAccount,
                                        createAccount: createAccount,
                                        accountStorage: accountStorage))
    }

    func test_HandleSceneDidLoad_AskViewToSetup() {
        //Given
        let validateAccountView = ValidateAccountViewSpy()
        sut.set(view: validateAccountView)

        //When
        sut.handleSceneDidLoad()

        //Then
        let expectedViewModel = ValidateAccountViewModel(showValidationAttemptsButton: .init(title: "Validation Attempts", isHidden: true),
                                                         validateAccountButton: .init(title: "Validate Account", isHidden: false),
                                                         createAccountButton: .init(title: "Create Account", isHidden: false),
                                                         usernameTextField: .init(palceholder: "Username"),
                                                         passwordTextField: .init(palceholder: "Password"),
                                                         passwordHint: "At least 8 characters\nAt least: an uppercased character, a lowercased character, a number, an special character\n")

        XCTAssertEqual(validateAccountView.receivedCalls, [.displayViewModel(expectedViewModel)])
    }

    func test_AccountDoesNotExists_HandleValidateAccount_DisplayRightAlert() {
        //Given
        let givenValidateAccountError: ValidateAccountError = .accontDoesNotExist
        validateAccount.executeMock = { $1(.failure(givenValidateAccountError)) }
        let validateAccountView = ValidateAccountViewSpy()
        sut.set(view: validateAccountView)

        //When
        sut.handleValidate(account: .init(username: "username", password: "password"))

        //Then
        let expectedValidatinAttepmtsButton: ButtonViewModel = .init(title: "Validation Attempts", isHidden: true)
        XCTAssertEqual(validateAccountView.receivedCalls, [.displayaActivityIndicator(true),
                                                           .displayaActivityIndicator(false),
                                                           .displayAlert(format(error: givenValidateAccountError)),
                                                           .displayValidationAttemptsButton(expectedValidatinAttepmtsButton)])
    }

    func test_InvalidPassword_HandleValidateAccount_DisplayRightAlert() {
        //Given
        let givenValidateAccountError: ValidateAccountError = .invalidPassword
        validateAccount.executeMock = { $1(.failure(givenValidateAccountError)) }
        let validateAccountView = ValidateAccountViewSpy()
        sut.set(view: validateAccountView)

        //When
        sut.handleValidate(account: .init(username: "username", password: "password"))

        //Then
        let expectedValidatinAttepmtsButton: ButtonViewModel = .init(title: "Validation Attempts", isHidden: true)
        XCTAssertEqual(validateAccountView.receivedCalls, [.displayaActivityIndicator(true),
                                                           .displayaActivityIndicator(false),
                                                           .displayAlert(format(error: givenValidateAccountError)),
                                                           .displayValidationAttemptsButton(expectedValidatinAttepmtsButton)])
    }

    func test_UnableToGetCurrentDate_HandleValidateAccount_DisplayRightAlert() {
        //Given
        let givenValidateAccountError: ValidateAccountError = .unableToGetCurrentDate(reason: "reason")
        validateAccount.executeMock = { $1(.failure(givenValidateAccountError)) }
        let validateAccountView = ValidateAccountViewSpy()
        sut.set(view: validateAccountView)

        //When
        sut.handleValidate(account: .init(username: "username", password: "password"))

        //Then
        let expectedValidatinAttepmtsButton: ButtonViewModel = .init(title: "Validation Attempts", isHidden: true)
        XCTAssertEqual(validateAccountView.receivedCalls, [.displayaActivityIndicator(true),
                                                           .displayaActivityIndicator(false),
                                                           .displayAlert(format(error: givenValidateAccountError)),
                                                           .displayValidationAttemptsButton(expectedValidatinAttepmtsButton)])
    }

    func test_UnableToGetCurrentLocation_HandleValidateAccount_DisplayRightAlert() {
        //Given
        let givenValidateAccountError: ValidateAccountError = .unableToGetCurrentLocation(reason: "reason")
        validateAccount.executeMock = { $1(.failure(givenValidateAccountError)) }
        let validateAccountView = ValidateAccountViewSpy()
        sut.set(view: validateAccountView)

        //When
        sut.handleValidate(account: .init(username: "username", password: "password"))

        //Then
        let expectedValidatinAttepmtsButton: ButtonViewModel = .init(title: "Validation Attempts", isHidden: true)
        XCTAssertEqual(validateAccountView.receivedCalls, [.displayaActivityIndicator(true),
                                                           .displayaActivityIndicator(false),
                                                           .displayAlert(format(error: givenValidateAccountError)),
                                                           .displayValidationAttemptsButton(expectedValidatinAttepmtsButton)])
    }

    func test_ValidateAccountSuccess_HandleValidateAccount_DisplaySuccessAlert() {
        //Given
        validateAccount.executeMock = { $1(.success(())) }
        let validateAccountView = ValidateAccountViewSpy()
        sut.set(view: validateAccountView)

        //When
        sut.handleValidate(account: .init(username: "username", password: "password"))

        //Then
        let expectedValidatinAttepmtsButton: ButtonViewModel = .init(title: "Validation Attempts", isHidden: false)
        let expectedAlert: AlertViewModel = .init(title: "Account is Valid",
                                                  message: "The account has been validated successfully",
                                                  action: .init(title: "Ok", handler: { }))
        XCTAssertEqual(validateAccountView.receivedCalls, [.displayaActivityIndicator(true),
                                                           .displayaActivityIndicator(false),
                                                           .displayAlert(expectedAlert),
                                                           .displayValidationAttemptsButton(expectedValidatinAttepmtsButton)])
    }

}

private extension ValidateAccountPresenterTests {
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


