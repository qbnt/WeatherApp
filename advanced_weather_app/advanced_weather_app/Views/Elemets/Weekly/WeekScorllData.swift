//
//  WeekScorllData.swift
//  advanced_weather_app
//
//  Created by Quentin Banet on 06/03/2025.
//

import SwiftUI

struct WeekScrollData: View {
    var dailyWeather: WeatherData.Daily

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(dailyWeather.time.indices, id: \.self) { index in
                    VStack {
                        Text(dailyWeather.time[index], formatter: dateFormatter)
                            .font(.headline)
                            .frame(width: 80, alignment: .center)
                            .padding(.top, 10)
                        
                        let weatherCondition = WeatherCondition(code: dailyWeather.weatherCode[index])
                        Text("\(weatherCondition.emoji)")
                            .padding(3)
                        
                        VStack {
                            Text("\(String(format: "%.0f", dailyWeather.temperature2mMax[index]))°C")
                                .foregroundColor(.red)
                            Text("\(String(format: "%.0f", dailyWeather.temperature2mMin[index]))°C")
                                .foregroundColor(.blue)
                        }
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

    private let dayFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"
        formatter.locale = Locale(identifier: "fr_FR")
        return formatter
    }()

    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM"
        formatter.locale = Locale(identifier: "fr_FR")
        return formatter
    }()

}
