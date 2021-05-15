//
//  GeoNameTimezone.swift
//  Account Validator
//
//  Created by Angel Betancourt on 14/05/21.
//

import Foundation

struct GeoNameTimezone: Codable {
    let sunrise: String
    let lng: Double
    let countryCode: String
    let gmtOffset: Double
    let rawOffset: Double
    let sunset: String
    let timezoneId: String
    let dstOffset: Double
    let countryName: String
    let time: String
    let lat: Double
}
