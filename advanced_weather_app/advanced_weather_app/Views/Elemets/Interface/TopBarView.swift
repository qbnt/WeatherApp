//
//  TopBarView.swift
//  weather_app
//
//  Created by Quentin Banet on 20/02/2025.
//

import SwiftUI
import CoreLocation

struct TopBarView: View {
    @EnvironmentObject var locationManager: LocationManager

    // Alert
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    // Utils
    @State private var searchText: String = ""
    @State private var citySuggestions: [City] = []
    @FocusState private var isFocused: Bool

    var body: some View {
        VStack {
            HStack {
                Text("Search:")
                    .padding(.leading)
                
                SearchBarView(isFocused: $isFocused, searchText: $searchText, citySuggestions: $citySuggestions)
                
                Divider()
                    .frame(height: 40)
                
                LocationButtonView(alertMessage: $alertMessage, showAlert: $showAlert)
                    .padding(.trailing)
            }
            .frame(maxWidth: .infinity, minHeight: 50)
            .background(Color.gray.opacity(0.4))
            .cornerRadius(30)
            .alert("Location :", isPresented: $showAlert) {
                Button("OK", role: .cancel) { }
                if isLocationDenied {
                    Button("Ouvrir les réglages") {
                        openSettings()
                    }
                }
            } message: {
                Text(alertMessage)
            }
            SuggestionView(citySuggestions: $citySuggestions, searchText: $searchText, isFocused: $isFocused)
        }
    }

    private var isLocationDenied: Bool {
        locationManager.authorizationStatus == .denied
    }

    private func openSettings() {
        if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(settingsURL, options: [:], completionHandler: nil)
        }
    }
}

struct TopBarView_Previews: PreviewProvider {
    static var previews: some View {
        TopBarView()
            .environmentObject(LocationManager())
    }
}
