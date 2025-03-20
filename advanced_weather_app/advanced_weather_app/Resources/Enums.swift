//
//  File.swift
//  weather_app
//
//  Created by Quentin Banet on 24/02/2025.
//

import Foundation
import SwiftUI

enum WeatherCondition {
    case clearSky
    case mainlyClear
    case partlyCloudy
    case overcast
    case fog
    case depositingRimeFog
    case drizzle
    case freezingDrizzle
    case rain
    case freezingRain
    case snowFall
    case snowGrains
    case rainShowers
    case snowShowers
    case thunderstorm
    case thunderstormWithHail
    case unknown

    init(code: Float) {
        let c = Int(code)
        switch c {
        case 0:
            self = .clearSky
        case 1:
            self = .mainlyClear
        case 2:
            self = .partlyCloudy
        case 3:
            self = .overcast
        case 45:
            self = .fog
        case 48:
            self = .depositingRimeFog
        case 51, 53, 55:
            self = .drizzle
        case 56, 57:
            self = .freezingDrizzle
        case 61, 63, 65:
            self = .rain
        case 66, 67:
            self = .freezingRain
        case 71, 73, 75:
            self = .snowFall
        case 77:
            self = .snowGrains
        case 80, 81, 82:
            self = .rainShowers
        case 85, 86:
            self = .snowShowers
        case 95:
            self = .thunderstorm
        case 96, 99:
            self = .thunderstormWithHail
        default:
            self = .unknown
        }
    }

    var description: String {
        switch self {
        case .clearSky:
            return "Clear sky"
        case .mainlyClear:
            return "Mainly clear"
        case .partlyCloudy:
            return "Partly cloudy"
        case .overcast:
            return "Overcast"
        case .fog:
            return "Fog"
        case .depositingRimeFog:
            return "Depositing rime fog"
        case .drizzle:
            return "Drizzle"
        case .freezingDrizzle:
            return "Freezing drizzle"
        case .rain:
            return "Rain"
        case .freezingRain:
            return "Freezing rain"
        case .snowFall:
            return "Snow fall"
        case .snowGrains:
            return "Snow grains"
        case .rainShowers:
            return "Rain showers"
        case .snowShowers:
            return "Snow showers"
        case .thunderstorm:
            return "Thunderstorm"
        case .thunderstormWithHail:
            return "Thunderstorm with hail"
        case .unknown:
            return "Unknown"
        }
    }

    var emoji: String {
        switch self {
        case .clearSky:
            return "☀️"
        case .mainlyClear:
            return "🌤"
        case .partlyCloudy:
            return "⛅️"
        case .overcast:
            return "☁️"
        case .fog, .depositingRimeFog:
            return "🌫"
        case .drizzle, .freezingDrizzle:
            return "🌧"
        case .rain, .rainShowers:
            return "🌧"
        case .freezingRain:
            return "❄️🌧"
        case .snowFall, .snowShowers:
            return "❄️"
        case .snowGrains:
            return "🌨"
        case .thunderstorm:
            return "⛈"
        case .thunderstormWithHail:
            return "⛈🧊"
        case .unknown:
            return "❓"
        }
    }
}

enum Tab: CaseIterable {
    case currently, today, weekly

    var tabInfo: (title: String, icon: String) {
        switch self {
        case .currently:
            return ("Currently", "house.fill")
        case .today:
            return ("Today", "sunrise.fill")
        case .weekly:
            return ("Week", "calendar")
        }
    }

    var view: AnyView {
        switch self {
        case .currently:
            return AnyView(CurrentlyView())
        case .today:
            return AnyView(TodayView())
        case .weekly:
            return AnyView(WeeklyView())
        }
    }
}

enum GraphOption: String, CaseIterable, Identifiable {
    case temperature = "Temperature"
    case wind = "Wind"
    
    var id: String { self.rawValue }
}
