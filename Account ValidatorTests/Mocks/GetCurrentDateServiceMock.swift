//
//  GetCurrentDateServiceMock.swift
//  Account ValidatorTests
//
//  Created by Angel Betancourt on 15/05/21.
//

@testable import Account_Validator

final class GetCurrentDateServiceMock: GetCurrentDateService {
    var getDateMock: (DeviceLocation, GetCurrentDateServiceHandler) -> Void = { _, _  in }
    func getDate(deviceLocation: DeviceLocation, completion: @escaping GetCurrentDateServiceHandler) {
        getDateMock(deviceLocation, completion)
    }
}
