//
//  CreateAccountImplTests.swift
//  Account ValidatorTests
//
//  Created by Angel Betancourt on 15/05/21.
//

import XCTest
@testable import Account_Validator

final class CreateAccountImplTests: XCTestCase {

    var sut: CreateAccountImpl!
    var accountStorage: AccountStorageMock!

    override func setUp() {
        super.setUp()
        accountStorage = .init()
        sut = .init(dependencies: .init(accountStorage: accountStorage))
    }

    func test_EmptyUsername_Execute_ReturnsInvalidUsernameError() {
        //Given
        let givenAccount = Account(username: "",
                                   password: "password")

        //When
        let receivedResult = sut.execute(account: givenAccount)

        //Then
        guard case .failure(let receivedError) = receivedResult else {
            XCTFail("The received result must be false as the given username is not an valid email")
            return
        }

        XCTAssertEqual(receivedError, .invalidUsername)
    }

    func test_InvalidUsername_Execute_ReturnsInvalidUsernameError() {
        //Given
        let givenAccount = Account(username: "username",
                                   password: "password")

        //When
        let receivedResult = sut.execute(account: givenAccount)

        //Then
        guard case .failure(let receivedError) = receivedResult else {
            XCTFail("The received result must be false as the given username is not an valid email")
            return
        }

        XCTAssertEqual(receivedError, .invalidUsername)
    }

    func test_NoMinimunLenghPassword_Execute_ReturnsInvalidPasswordError() {
        //Given
        let givenAccount = Account(username: "username@domain.com",
                                   password: "Pas.1")

        //When
        let receivedResult = sut.execute(account: givenAccount)

        //Then
        guard case .failure(let receivedError) = receivedResult else {
            XCTFail("The received result must be false as the given password is not valid")
            return
        }

        XCTAssertEqual(receivedError, .invalidPassword)
    }

    func test_NoUppercasedCharacterPassword_Execute_ReturnsInvalidPasswordError() {
        //Given
        let givenAccount = Account(username: "username@domain.com",
                                   password: "password.1")

        //When
        let receivedResult = sut.execute(account: givenAccount)

        //Then
        guard case .failure(let receivedError) = receivedResult else {
            XCTFail("The received result must be false as the given password is not valid")
            return
        }

        XCTAssertEqual(receivedError, .invalidPassword)
    }

    func test_NoLowercasedCharacterPassword_Execute_ReturnsInvalidPasswordError() {
        //Given
        let givenAccount = Account(username: "username@domain.com",
                                   password: "PASSWORD.1")

        //When
        let receivedResult = sut.execute(account: givenAccount)

        //Then
        guard case .failure(let receivedError) = receivedResult else {
            XCTFail("The received result must be false as the given password is not valid")
            return
        }

        XCTAssertEqual(receivedError, .invalidPassword)
    }

    func test_NoNumberCharacterPassword_Execute_ReturnsInvalidPasswordError() {
        //Given
        let givenAccount = Account(username: "username@domain.com",
                                   password: "Password.")

        //When
        let receivedResult = sut.execute(account: givenAccount)

        //Then
        guard case .failure(let receivedError) = receivedResult else {
            XCTFail("The received result must be false as the given password is not valid")
            return
        }

        XCTAssertEqual(receivedError, .invalidPassword)
    }

    func test_NoSpecialCharacterPassword_Execute_ReturnsInvalidPasswordError() {
        //Given
        let givenAccount = Account(username: "username@domain.com",
                                   password: "Password1")

        //When
        let receivedResult = sut.execute(account: givenAccount)

        //Then
        guard case .failure(let receivedError) = receivedResult else {
            XCTFail("The received result must be false as the given password is not valid")
            return
        }

        XCTAssertEqual(receivedError, .invalidPassword)
    }

    func test_ValidPassword_Execute_ReturnsInvalidPasswordError() {
        //Given
        let givenAccount = Account(username: "username@domain.com",
                                   password: "Password.1")

        //When
        let receivedResult = sut.execute(account: givenAccount)

        //Then
        guard case .success = receivedResult else {
            XCTFail("The received result must be success as the given password is valid")
            return
        }
    }
}
