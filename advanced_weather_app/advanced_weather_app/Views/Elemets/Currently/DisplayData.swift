//
//  DisplayData.swift
//  medium_weather_app
//
//  Created by Quentin Banet on 04/03/2025.
//

import SwiftUI

struct DisplayData: View {
    var weather: WeatherData.Current
    
    
    private let houreFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        formatter.locale = Locale(identifier: "fr_FR")
        return formatter
    }()

    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM"
        formatter.locale = Locale(identifier: "fr_FR")
        return formatter
    }()
    
    var body: some View {
        HStack {
            Text(dateFormatter.string(from: weather.time))
                .font(.title)
            Divider()
                .frame(height: 30)
            Text(houreFormatter.string(from: weather.time))
                .font(.title2)
        }
        .padding()
        VStack {
            Text("\(weather.weatherCondition.emoji)")
                .font(Font.custom("weatherEmoji", size: 84))
            Text("\(weather.weatherCondition.description)")
                .font(.title2)
        }
        .padding()
        
        VStack {
            Text("\(String(format: "%.0f", weather.temperature2m))°C")
                .font(.title)
                .bold()
            Text("Apparent: \(String(format: "%.0f", weather.apparentTemperature))°C")
                .font(.caption)
        }
        
        HStack {
            Image(systemName: "wind")
            Text("\(String(format: "%.0f", weather.windSpeed10m)) km/h")
                .font(.title3)
        }
        .padding()
    }
}

struct DisplayDataHorizontal: View {
    var weather: WeatherData.Current
    
    private let houreFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        formatter.locale = Locale(identifier: "fr_FR")
        return formatter
    }()

    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM"
        formatter.locale = Locale(identifier: "fr_FR")
        return formatter
    }()
    
    var body: some View {
        VStack {
            HStack {
                Text(dateFormatter.string(from: weather.time))
                    .font(.title2)
                Divider()
                    .frame(height: 30)
                Text(houreFormatter.string(from: weather.time))
                    .font(.title3)
            }
            HStack(alignment: .center, spacing: 20) {
                VStack {
                    Text("\(weather.weatherCondition.emoji)")
                        .font(.system(size: 64))
                    Text("\(weather.weatherCondition.description)")
                        .font(.headline)
                }
                
                Divider()
                    .frame(height: 50)
                
                VStack {
                    Text("\(String(format: "%.0f", weather.temperature2m))°C")
                        .font(.title)
                        .bold()
                    
                    Text("Ressenti: \(String(format: "%.0f", weather.apparentTemperature))°C")
                        .font(.caption)
                }
                
                Divider()
                    .frame(height: 50)
                
                VStack {
                    Image(systemName: "wind")
                        .font(.title2)
                    
                    Text("\(String(format: "%.0f", weather.windSpeed10m)) km/h")
                        .font(.headline)
                }
            }
        }
        .padding()
    }
}
