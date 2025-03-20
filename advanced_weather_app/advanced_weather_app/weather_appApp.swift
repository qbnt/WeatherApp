//
//  weather_appApp.swift
//  weather_app
//
//  Created by Quentin Banet on 20/02/2025.
//

import SwiftUI
import CoreLocation
import Combine

@main
struct weather_appApp: App {
    @StateObject private var locationManageur = LocationManager()
    @StateObject private var weatherManager = WeatherManager()
    
    var body: some Scene {
            WindowGroup {
                ContentView()
                    .environmentObject(locationManageur)
                    .environmentObject(weatherManager)
            }
        }
}
