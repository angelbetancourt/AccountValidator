//
//  ValidateAccountImplTests.swift
//  Account ValidatorTests
//
//  Created by Angel Betancourt on 15/05/21.
//

import XCTest
@testable import Account_Validator

final class ValidateAccountImplTests: XCTestCase {

    var sut: ValidateAccountImpl!

    var getCurrentDateService: GetCurrentDateServiceMock!
    var getCurrentLocationService: GetCurrentLocationServiceMock!
    var accountStorage: AccountStorageMock!
    var accountValidationStorage: AccountValidationStorageMock!

    override func setUp() {
        super.setUp()
        getCurrentDateService = .init()
        getCurrentLocationService = .init()
        accountStorage = .init()
        accountValidationStorage = .init()
        sut = .init(dependencies: .init(getCurrentDateService: getCurrentDateService,
                                        getCurrentLocationService: getCurrentLocationService,
                                        accountStorage: accountStorage,
                                        accountValidationStorage: accountValidationStorage))
    }

    func test_LocationServiceReturnsError_Execute_CallCompletionWithLocationServceError() {
        // Given:

        let givenAccount = Account(username: "username", password: "password")
        let givenLocationServiceErrorDescription = "Location Service error description"
        let givenLocationServiceError = MockError(errorDescription: givenLocationServiceErrorDescription)
        getCurrentLocationService.getLocationMock = { $0(.failure(givenLocationServiceError)) }
        let validateAccountResultSpy = ValidateAccountResultSpy()

        //When
        sut.execute(account: givenAccount, completion: validateAccountResultSpy.handler)

        //Then
        guard case .failure(let reason) = validateAccountResultSpy.receivedResult else {
            XCTFail("The received result mst be a failure")
            return
        }

        XCTAssertEqual(reason, .unableToGetCurrentLocation(reason: givenLocationServiceErrorDescription),
                       "The received error must be unableToGetCurrentLocation and the reason must be the location error localized description")

        XCTAssertEqual(accountValidationStorage.receivedValidationAttempts, [],
                       "If location service faild it must not save a validation attempts")
    }

    func test_DateServiceReturnsError_Execute_CallCompletionWithDateServiceError() {
        // Given:

        let validateAccountResultSpy = ValidateAccountResultSpy()

        let givenAccount = Account(username: "username", password: "password")
        let givenDateServiceErrorDescription = "Date Service Error description"
        let givenDateServiceError = MockError(errorDescription: givenDateServiceErrorDescription)
        getCurrentLocationService.getLocationMock = { $0(.success(.init(latitude: 334.4530, longitude: 344446.0454))) }
        getCurrentDateService.getDateMock = { $1(.failure(givenDateServiceError)) }


        //When
        sut.execute(account: givenAccount, completion: validateAccountResultSpy.handler)

        //Then
        guard case .failure(let reason) = validateAccountResultSpy.receivedResult else {
            XCTFail("The received result mst be a failure")
            return
        }

        XCTAssertEqual(reason, .unableToGetCurrentDate(reason: givenDateServiceErrorDescription),
                       "The received error must be unableToGetCurrentDate and the reason must be the date service error localized description")

        XCTAssertEqual(accountValidationStorage.receivedValidationAttempts, [],
                       "If date service faild it must not save a validation attempts")
    }

    func test_AccountNotExists_Execute_CallCompletionWithAccountDoesNotExistsError() {
        // Given:

        let validateAccountResultSpy = ValidateAccountResultSpy()

        let givenServiceDate = Date()
        let givenAccount = Account(username: "username", password: "password")
        getCurrentLocationService.getLocationMock = { $0(.success(.init(latitude: 334.4530, longitude: 344446.0454))) }
        getCurrentDateService.getDateMock = { $1(.success(givenServiceDate)) }
        accountStorage.fetchMock = { _ in return nil }

        //When
        sut.execute(account: givenAccount, completion: validateAccountResultSpy.handler)

        //Then
        guard case .failure(let reason) = validateAccountResultSpy.receivedResult else {
            XCTFail("The received result mst be a failure")
            return
        }

        XCTAssertEqual(reason, .accontDoesNotExist,
                       "The received error must be accontDoesNotExist")

        let expectedValidatonAttempt = AccountValidationAttempt(accountUsername: givenAccount.username,
                                                                date: givenServiceDate,
                                                                result: .denied(reason: .accontDoesNotExist))

        XCTAssertEqual(accountValidationStorage.receivedValidationAttempts, [expectedValidatonAttempt])
    }

    func test_AccountPasswordMissmatch_Execute_CallCompletionWithAccountPasswordInvalid() {
        // Given:

        let validateAccountResultSpy = ValidateAccountResultSpy()

        let givenServiceDate = Date()
        let givenAccount = Account(username: "username", password: "password")
        let givenStoredAccount = Account(username: "username", password: "otherpassword")
        getCurrentLocationService.getLocationMock = { $0(.success(.init(latitude: 334.4530, longitude: 344446.0454))) }
        getCurrentDateService.getDateMock = { $1(.success(givenServiceDate)) }
        accountStorage.fetchMock = { _ in return givenStoredAccount }

        //When
        sut.execute(account: givenAccount, completion: validateAccountResultSpy.handler)

        //Then
        guard case .failure(let reason) = validateAccountResultSpy.receivedResult else {
            XCTFail("The received result mst be a failure")
            return
        }

        XCTAssertEqual(reason, .invalidPassword,
                       "The received error must be invalidPassword")

        let expectedValidatonAttempt = AccountValidationAttempt(accountUsername: givenAccount.username,
                                                                date: givenServiceDate,
                                                                result: .denied(reason: .invalidPassword))

        XCTAssertEqual(accountValidationStorage.receivedValidationAttempts, [expectedValidatonAttempt])
    }

    func test_ValidAccount_Execute_StoreValidationAttemptAsApproved() {
        // Given:

        let validateAccountResultSpy = ValidateAccountResultSpy()

        let givenServiceDate = Date()
        let givenAccount = Account(username: "username", password: "password")
        let givenStoredAccount = Account(username: "username", password: "password")
        getCurrentLocationService.getLocationMock = { $0(.success(.init(latitude: 334.4530, longitude: 344446.0454))) }
        getCurrentDateService.getDateMock = { $1(.success(givenServiceDate)) }
        accountStorage.fetchMock = { _ in return givenStoredAccount }

        //When
        sut.execute(account: givenAccount, completion: validateAccountResultSpy.handler)

        //Then
        guard case .success = validateAccountResultSpy.receivedResult else {
            XCTFail("The received result mst be a success")
            return
        }

        let expectedValidatonAttempt = AccountValidationAttempt(accountUsername: givenAccount.username,
                                                                date: givenServiceDate,
                                                                result: .approved)

        XCTAssertEqual(accountValidationStorage.receivedValidationAttempts, [expectedValidatonAttempt])
    }
}

final class ValidateAccountResultSpy {
    var receivedResult: ValidateAccountResult?
    lazy var handler: ValidateAccountHandler = { self.receivedResult = $0 }
}

struct MockError: LocalizedError {
    var errorDescription: String?
}
