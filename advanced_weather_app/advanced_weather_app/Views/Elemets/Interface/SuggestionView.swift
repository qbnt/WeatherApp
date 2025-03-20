//
//  SuggestionView.swift
//  medium_weather_app
//
//  Created by Quentin Banet on 27/02/2025.
//

import SwiftUI
import CoreLocation

struct SuggestionView: View {
    @EnvironmentObject var locationManager: LocationManager
    @EnvironmentObject var weatherManager: WeatherManager

    @Binding var citySuggestions: [City]
    @Binding var searchText: String
    @FocusState.Binding var isFocused: Bool
    
    var body: some View {
        if isFocused && !citySuggestions.isEmpty && searchText.count > 2 {
            List(citySuggestions) { city in
                Button(action: {
                    locationManager.userLocation = CLLocation(latitude: city.latitude, longitude: city.longitude)
                    weatherManager.updateSelectedCity(city: city)
                    
                    Task {
                        await weatherManager.fetchWeather()
                    }
                    
                    searchText.removeAll()
                    citySuggestions.removeAll()
                    isFocused = false
                }) {
                    HStack {
                        Text(city.name)
                            .font(.headline)
                        Spacer()
                        Text(city.admin1 ?? "")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        if (city.admin1 != nil && city.country != nil) {
                            Text(" - ")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                        Text(city.country ?? "")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                }
            }
            .listStyle(InsetListStyle())
            .cornerRadius(8)
            .scrollIndicators(.hidden)
        }
    }
}

#Preview {
    @Previewable @State var searchText: String = "Tou"
    @Previewable @State var citySuggestions: [City] = []
    @FocusState var isFocused: Bool

    SuggestionView(citySuggestions: $citySuggestions, searchText: $searchText, isFocused: $isFocused)
}
