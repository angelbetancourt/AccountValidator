//
//  GetCurrentLocationCoreLocationService.swift
//  Account Validator
//
//  Created by Angel Betancourt on 14/05/21.
//

import Foundation

import CoreLocation

final class GetCurrentLocationCoreLocationService: NSObject {

    struct GetLocationError: LocalizedError {
        var errorDescription: String?
    }

    private lazy var locationManager: CLLocationManager = {
        let locationManager = CLLocationManager()
        locationManager.delegate = self
        return locationManager
    }()

    private var locationIsAuthorized: Bool {
        locationManager.authorizationStatus == .authorizedWhenInUse ||
            locationManager.authorizationStatus == .authorizedAlways
    }



    private var currentLocation: CLLocation? { locationManager.location }
    private var locationListeners: [GetCurrentLocationServiceHandler] = []
}

extension GetCurrentLocationCoreLocationService: GetCurrentLocationService {
    func getLocation(completion: @escaping GetCurrentLocationServiceHandler) {

        switch locationManager.authorizationStatus {

        case .notDetermined:
            locationListeners.append(completion)
            locationManager.requestWhenInUseAuthorization()

        case .denied, .restricted:
            completion(.failure(GetLocationError(errorDescription: "Location is Denied")))

        case .authorizedAlways, .authorizedWhenInUse:
            guard let currentLocation = currentLocation else {
                locationListeners.append(completion)
                locationManager.requestLocation()
                return
            }
            completion(.success(.init(latitude: currentLocation.coordinate.latitude, longitude: currentLocation.coordinate.longitude)))

        @unknown default:
            completion(.failure(GetLocationError(errorDescription: "Unable to determine location authorization status")))
        }
    }
}

extension GetCurrentLocationCoreLocationService: CLLocationManagerDelegate {

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        manager.requestLocation()
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        notify(result: .failure(error))
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else {
            return
        }

        notify(result: .success(.init(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)))
    }
}

private extension GetCurrentLocationCoreLocationService {
    func notify(result: GetCurrentLocationServiceResult) {
        locationListeners.forEach { $0(result) }
        locationListeners.removeAll()
    }
}
