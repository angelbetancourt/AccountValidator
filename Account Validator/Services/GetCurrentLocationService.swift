//
//  GetCurrentLocationService.swift
//  Account Validator
//
//  Created by Angel Betancourt on 14/05/21.
//

import Foundation

typealias GetCurrentLocationServiceResult = Result<DeviceLocation, Error>
typealias GetCurrentLocationServiceHandler = (GetCurrentLocationServiceResult) -> Void

protocol GetCurrentLocationService {
    func getLocation(completion: @escaping GetCurrentLocationServiceHandler)
}
