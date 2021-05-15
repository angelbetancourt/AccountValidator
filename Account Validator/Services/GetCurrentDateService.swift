//
//  GetCurrentDateService.swift
//  Account Validator
//
//  Created by Angel Betancourt on 14/05/21.
//

import Foundation

typealias GetCurrentDateServiceResult = Result<Date, Error>
typealias GetCurrentDateServiceHandler = (GetCurrentDateServiceResult) -> Void

protocol GetCurrentDateService {
    func getDate(deviceLocation: DeviceLocation, completion: @escaping GetCurrentDateServiceHandler)
}


