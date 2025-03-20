//
//  GraphView.swift
//  medium_weather_app
//
//  Created by Quentin Banet on 04/03/2025.
//

import SwiftUI
import Charts

struct GraphView: View {
    @EnvironmentObject var weatherManager: WeatherManager
    @State private var selectedOption: GraphOption = .temperature
    
    // Data
    var today: Date
    var todayWeather: [(index: Int, date: Date)]
    var hourlyWeather: WeatherData.Hourly

    var body: some View {
        let minTemp = hourlyWeather.temperature2m.min() ?? 0
        let maxTemp = hourlyWeather.temperature2m.max() ?? 40
        let minWind = hourlyWeather.windSpeed10m.min() ?? 0
        let maxWind = hourlyWeather.windSpeed10m.max() ?? 120

        VStack(spacing: 16) {
            Picker("Graphique", selection: $selectedOption) {
                ForEach(GraphOption.allCases) { option in
                    Text(option.rawValue).tag(option)
                }
            }
            .pickerStyle(.segmented)
            .padding(.horizontal)
            
            if !todayWeather.isEmpty {
                Chart {
                    ForEach(todayWeather, id: \.index) { item in
                        if selectedOption == .temperature {
                            LineMark(
                                x: .value("Heure", hourlyWeather.time[item.index]),
                                y: .value("Température", hourlyWeather.temperature2m[item.index])
                            )
                            .foregroundStyle(.red)
                            .symbol(Circle())
                            .interpolationMethod(.catmullRom)
                        } else {
                            LineMark(
                                x: .value("Heure", hourlyWeather.time[item.index]),
                                y: .value("Vent", hourlyWeather.windSpeed10m[item.index])
                            )
                            .foregroundStyle(.blue)
                            .symbol(Circle())
                            .interpolationMethod(.catmullRom)
                        }
                        if (item.index % 4 == 0) {
                            RuleMark(x: .value("Heure", hourlyWeather.time[item.index]))
                                .foregroundStyle(.gray.opacity(0.5))
                                .lineStyle(StrokeStyle(lineWidth: 1, dash: [5]))
                                .annotation(position: .bottom) {
                                    Text(hourlyWeather.time[item.index], style: .time)
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                }
                        }
                    }
                }
                .chartXAxis(.hidden)
                .chartYScale(domain: selectedOption == .temperature ? (minTemp - 2)...(maxTemp + 2) : (minWind - 5)...(maxWind + 5))
                .chartYAxis {
                    AxisMarks(position: .leading) { value in
                        AxisValueLabel {
                            if let intValue = value.as(Int.self) {
                                if (selectedOption == .temperature) {
                                    Text("\(intValue)°C")
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                } else {
                                    Text("\(intValue) km/h")
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                }
                            }
                        }
                        AxisGridLine()
                        AxisTick()
                    }
                }
                .padding()
            } else {
                VStack {
                    NoDataView()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .padding()
    }
}

#Preview {
    // Exemple de fausses données pour la preview
    let sampleHourly = WeatherData.Hourly(
        time: (0..<24).compactMap {
            Calendar.current.date(byAdding: .hour, value: $0, to: Date())
        },
        temperature2m: (0..<24).map { _ in Float.random(in: 10...30) },
        apparentTemperature: (0..<24).map { _ in Float.random(in: 9...29) },
        weatherCode: (0..<24).map { _ in Float(Int.random(in: 0...3)) },
        windSpeed10m: (0..<24).map { _ in Float.random(in: 5...200) }
    )
    let sampleTodayWeather: [(Int, Date)] = (0..<24).compactMap { i in
        if let date = Calendar.current.date(byAdding: .hour, value: i, to: Date()) {
            return (i, date)
        }
        return nil
    }

    GraphView(
        today: Date(),
        todayWeather: sampleTodayWeather,
        hourlyWeather: sampleHourly
    )
    .environmentObject(WeatherManager())
}
