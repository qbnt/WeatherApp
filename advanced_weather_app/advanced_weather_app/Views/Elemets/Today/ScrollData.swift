//
//  ScrollData.swift
//  medium_weather_app
//
//  Created by Quentin Banet on 04/03/2025.
//

import SwiftUI

struct ScrollData: View {
    var todayWeather: [(Int, Date)]
    var hourlyWeather: WeatherData.Hourly

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(todayWeather, id: \.0) { item in
                    let index = item.0
                    let date = item.1
                    
                    VStack {
                        Text(date, formatter: timeFormatter)
                            .font(.headline)
                            .frame(width: 80, alignment: .center)
                            .padding(.top, 10)
                        
                        let weatherCondition = WeatherCondition(code: hourlyWeather.weatherCode[index])
                        VStack {
                            Text("\(weatherCondition.emoji)")
                            Text("\(String(format: "%.0f", hourlyWeather.temperature2m[index]))°C")
                                .bold()
                        }
                        .padding(3)
                        
                        Text("\(String(format: "%.0f", hourlyWeather.windSpeed10m[index])) km/h")
                            .frame(width: 80, alignment: .center)
                            .padding(.bottom, 10)
                            .padding(.horizontal, 5)
                    }
                    .shadow(color: Color.gray.opacity(0.6), radius: 10, x: 0, y: -10)
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(30)
                }
                .padding(.horizontal, 2)
            }
            .padding(.horizontal, 20)
        }
        .mask(
            LinearGradient(
                gradient: Gradient(stops: [
                    .init(color: Color.black.opacity(0.0), location: 0.0),
                    .init(color: Color.black.opacity(1.0), location: 0.08),
                    .init(color: Color.black.opacity(1.0), location: 0.9),
                    .init(color: Color.black.opacity(0.0), location: 1.0)
                ]),
                startPoint: .leading,
                endPoint: .trailing
            )
        )
    }

    private let timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        formatter.locale = Locale(identifier: "fr_FR")
        return formatter
    }()
}

#Preview {
    let sampleHourlyWeather = WeatherData.Hourly(
        time: (0..<24).map { Calendar.current.date(byAdding: .hour, value: $0, to: Date())! },
        temperature2m: (0..<24).map { _ in Float.random(in: 10...25) },
        apparentTemperature: (0..<24).map { _ in Float.random(in: 9...24) },
        weatherCode: (0..<24).map { _ in Float(Int.random(in: 1...3)) },
        windSpeed10m: (0..<24).map { _ in Float.random(in: 5...200) }
    )

    let sampleTodayWeather: [(Int, Date)] = (0..<24).map { index in
        (index, Calendar.current.date(byAdding: .hour, value: index, to: Date())!)
    }

    ScrollData(todayWeather: sampleTodayWeather, hourlyWeather: sampleHourlyWeather)
}
