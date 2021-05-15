//
//  GetCurrentLocationServiceMock.swift
//  Account ValidatorTests
//
//  Created by Angel Betancourt on 15/05/21.
//

@testable import Account_Validator

final class GetCurrentLocationServiceMock: GetCurrentLocationService {
    var getLocationMock: (GetCurrentLocationServiceHandler) -> Void = { _  in }
    func getLocation(completion: @escaping GetCurrentLocationServiceHandler) {
        getLocationMock(completion)
    }
}
