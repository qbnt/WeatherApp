//
//  LocationsManager.swift
//  weather_app
//
//  Created by Quentin Banet on 20/02/2025.
//

import Foundation
import CoreLocation

import CoreLocation
import SwiftUICore

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {

    private let locationManager = CLLocationManager()

    @Published var isLoadingPositon: Bool = false
    
    @Published var userLocation: CLLocation? = nil
    @Published var authorizationStatus: CLAuthorizationStatus = .notDetermined
    
    private var locationCompletion: ((CLLocation?) -> Void)?
    
    // Init et fonctions framework
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            DispatchQueue.main.async {
                self.userLocation = location
                self.locationCompletion?(location)
                self.locationCompletion = nil
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Erreur de localisation : \(error.localizedDescription)")
        DispatchQueue.main.async {
            self.locationCompletion?(nil)
            self.locationCompletion = nil
        }
    }
    
    // Verif autorisations
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        DispatchQueue.main.async {
            self.authorizationStatus = manager.authorizationStatus
        }

        switch manager.authorizationStatus {
        case .notDetermined:
            print("Autorisation non demandée")
        case .restricted, .denied:
            print("Accès refusé")
        case .authorizedAlways, .authorizedWhenInUse:
            print("✅ Autorisation accordée, démarrage de la localisation")
        @unknown default:
            print("Cas inconnu")
        }
    }
    
    // Update Location
    func requestUserLocation(completion: @escaping (CLLocation?) -> Void) {
        self.locationCompletion = completion
        self.locationManager.requestLocation()
    }
}

// Preview
extension LocationManager {
    static var preview: LocationManager {
        let manager = LocationManager()
        manager.userLocation = CLLocation(latitude: 42.6886, longitude: 2.8948)
        return manager
    }
}
