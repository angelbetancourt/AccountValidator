//
//  GetCurrentDateGeoNamesService.swift
//  Account Validator
//
//  Created by Angel Betancourt on 14/05/21.
//

import Foundation

// Service implemented by consuming geonames API. See https://www.geonames.org/export/web-services.html
final class GetCurrentDateGeoNamesService: GetCurrentDateService {

    struct GetDateError: LocalizedError {
        var errorDescription: String?
    }

    private struct GeoNamesAPISettings {
        static let dateFormat = "yyyy-MM-dd HH:mm"
    }

    private lazy var urlSession: URLSession = .shared

    private lazy var geoNamesURLComponents: URLComponents = {
        var urlComponents = URLComponents()
        urlComponents.scheme = "http"
        urlComponents.host = "api.geonames.org"
        urlComponents.path = "/timezoneJSON"
        urlComponents.queryItems = [.init(name: "formatted", value: "true"),
                                    .init(name: "username", value: "qa_mobile_easy"),
                                    .init(name: "style", value: "full")]
        return urlComponents
    }()

    func getDate(deviceLocation: DeviceLocation, completion: @escaping GetCurrentDateServiceHandler) {

        let notify: (GetCurrentDateServiceResult) -> Void = { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }

        guard let url = makeURL(deviceLocation: deviceLocation) else {
            notify(.failure(GetDateError(errorDescription: "Unable to build request")))
            return
        }

        let task = urlSession.dataTask(with: url, completionHandler: { [weak self] (data, response, error) in
            if let error = error {
                notify(.failure(error))
                return
            }

            guard let data = data,
                  let geoNameTimezone = try? JSONDecoder().decode(GeoNameTimezone.self, from: data),
                  let date = self?.makeDate(geoNameTimezone: geoNameTimezone) else {
                notify(.failure(GetDateError(errorDescription: "Unable to read service response")))
                return
            }

            notify(.success(date))
        })

        task.resume()
    }
}

private extension GetCurrentDateGeoNamesService {
    func makeURL(deviceLocation: DeviceLocation) -> URL? {
        var urlComponents = self.geoNamesURLComponents
        urlComponents.queryItems?.append(contentsOf: deviceLocation.queryItems)
        return urlComponents.url
    }

    func makeDate(geoNameTimezone: GeoNameTimezone) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(identifier: geoNameTimezone.timezoneId)
        dateFormatter.dateFormat = GeoNamesAPISettings.dateFormat
        return dateFormatter.date(from: geoNameTimezone.time)
    }
}

private extension DeviceLocation {
    var queryItems: [URLQueryItem] {
        [.init(name: "lat", value: latitude.description),
         .init(name: "lng", value: longitude.description)]
    }
}
