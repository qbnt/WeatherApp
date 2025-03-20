//
//  LocationButtonView.swift
//  medium_weather_app
//
//  Created by Quentin Banet on 27/02/2025.
//

import SwiftUI
import CoreLocation

struct LocationButtonView: View {
    @EnvironmentObject var locationManager: LocationManager
    @EnvironmentObject var weatherManager: WeatherManager
    
    @Binding var alertMessage: String
    @Binding var showAlert: Bool
    
    //----------------- Fonctions interne -----------------\\
    
    private func handleLocationButton() {
        locationManager.isLoadingPositon = true
        if isLocationAuthorized {
            locationManager.requestUserLocation { location in
                if let location = location {
                    Task {
                        if let city = await searchGeo(coordinates: location.coordinate) {
                            weatherManager.updateSelectedCity(city: city)
                            await weatherManager.fetchWeather()
                        } else {
                            DispatchQueue.main.async {
                                alertMessage = "Aucune ville trouvée pour cette position."
                                showAlert = true
                            }
                        }
                        locationManager.isLoadingPositon = false
                    }
                } else {
                    alertMessage = "Impossible d'obtenir votre position. Vérifiez vos paramètres de localisation."
                    showAlert = true
                }
            }
        } else {
            alertMessage = "⚠️ L'accès à la localisation est refusé. Vous pouvez le modifier dans les paramètres."
            showAlert = true
        }
    }
    
    private var isLocationAuthorized: Bool {
        let status = locationManager.authorizationStatus
        return status == .authorizedWhenInUse || status == .authorizedAlways
    }
    
    private func searchGeo(coordinates: CLLocationCoordinate2D) async -> City? {
        let geocoder = CLGeocoder()
        let location = CLLocation(latitude: coordinates.latitude, longitude: coordinates.longitude)

        do {
            let placemarks = try await geocoder.reverseGeocodeLocation(location)
            if let placemark = placemarks.first {
                return City(
                    id: UUID().hashValue,
                    name: placemark.locality ?? "Inconnu",
                    latitude: coordinates.latitude,
                    longitude: coordinates.longitude,
                    admin1: placemark.administrativeArea,
                    country: placemark.country
                )
            }
        } catch {
            print("Erreur lors de la recherche de la ville: \(error.localizedDescription)")
        }
        return nil
    }
    
    //----------------- Element -----------------\\
    var body: some View {
        Button(action: {
            handleLocationButton()
        }) {
            Image(systemName: "location.circle")
                .resizable()
                .frame(width: 20, height: 20)
                .foregroundColor(isLocationAuthorized ? .blue : .gray)
                .padding()
        }
    }
}

#Preview {
    @Previewable @State var alertMessage: String = ""
    @Previewable @State var showAlert: Bool = true

    LocationButtonView(alertMessage: $alertMessage, showAlert: $showAlert)
        .environmentObject(WeatherManager())
        .environmentObject(LocationManager())
}
