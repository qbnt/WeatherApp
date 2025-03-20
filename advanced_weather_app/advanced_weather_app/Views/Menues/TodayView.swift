//
//  TodayView.swift
//  weather_app
//
//  Created by Quentin Banet on 20/02/2025.
//

import SwiftUI

struct TodayView: View {
    @EnvironmentObject var weatherManager: WeatherManager
    @Environment(\.horizontalSizeClass) var horizontalSizeClass

    // Date de la ville recherchée
    var today: Date {
        if let utcOffsetSeconds = weatherManager.weatherData?.utcOffsetSeconds {
            return Calendar.current.startOfDay(for: Calendar.current.date(byAdding: .second, value: utcOffsetSeconds, to: Date()) ?? Date())
        } else {
            return Calendar.current.startOfDay(for: Date())
        }
    }

    // Météo de la ville recherchée
    var todayWeather: [(Int, Date)] {
        guard let hourlyWeather = weatherManager.weatherData?.hourly else { return [] }
        return hourlyWeather.time.enumerated().filter { index, date in
            return Calendar.current.isDate(date, inSameDayAs: today)
        }
    }

    var body: some View {
        GeometryReader { geometry in
            VStack {
                if let hourlyWeather = weatherManager.weatherData?.hourly {
                    
                    CityData(selectedCity: weatherManager.selectedCity)
                    
                    Divider()
                    
                    Spacer()
                    VStack {
                        if ((UIDevice.current.userInterfaceIdiom == .phone) && geometry.size.width < geometry.size.height || !(UIDevice.current.userInterfaceIdiom == .phone)) {
                            GraphView(today: today, todayWeather: todayWeather, hourlyWeather: hourlyWeather)
                        }
                        ScrollData(todayWeather: todayWeather, hourlyWeather: hourlyWeather)
                            .padding(.bottom, 8)
                    }
                    Spacer()
                    
                } else {
                    NoDataView()
                }
            }
            .ignoresSafeArea()
        }
    }
}
