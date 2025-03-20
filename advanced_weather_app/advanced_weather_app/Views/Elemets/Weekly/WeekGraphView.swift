//
//  WeekGraphView.swift
//  advanced_weather_app
//
//  Created by Quentin Banet on 07/03/2025.
//

import SwiftUI
import Charts

struct WeekGraphView: View {

    var dailyWeather: WeatherData.Daily

    var body: some View {
        if !dailyWeather.time.isEmpty {
            VStack {
                Chart {
                    ForEach(dailyWeather.time.indices, id: \.self) { index in
                        LineMark(
                            x: .value("Day", dailyWeather.time[index]),
                            y: .value("Max temp", dailyWeather.temperature2mMax[index]),
                            series: .value("Temp", "Max")
                        )
                        .foregroundStyle(.red)
                        .symbol(Circle())
                        .interpolationMethod(.catmullRom)
                    }
                    
                    ForEach(dailyWeather.time.indices, id: \.self) { index in
                        LineMark(
                            x: .value("Day", dailyWeather.time[index]),
                            y: .value("Min temp", dailyWeather.temperature2mMin[index]),
                            series: .value("Temp", "Min")
                        )
                        .foregroundStyle(.blue)
                        .symbol(Circle())
                        .interpolationMethod(.catmullRom)
                    }
                }
                .chartXAxis {
                    AxisMarks { value in
                        AxisGridLine()
                        AxisValueLabel(format: .dateTime.day(.twoDigits).month(.twoDigits))
                    }
                }
                .chartYAxis {
                    AxisMarks(position: .leading) { value in
                        AxisValueLabel {
                            if let temp = value.as(Double.self) {
                                Text("\(Int(temp))ºC")
                            }
                        }
                        AxisTick()
                        AxisGridLine()
                    }
                }
                HStack {
                    Image(systemName: "point.topleft.down.to.point.bottomright.curvepath")
                        .foregroundStyle(.red)
                        .font(.caption)
                        .rotationEffect(.degrees(270))
                    Text("Max Temperature")
                        .foregroundStyle(.red)
                        .font(.caption)
                    Divider()
                        .frame(width: 50, height: 20)
                    Image(systemName: "point.topleft.down.to.point.bottomright.curvepath")
                        .foregroundStyle(.blue)
                        .font(.caption)
                        .rotationEffect(.degrees(270))
                    Text("Min Temperature")
                        .foregroundStyle(.blue)
                        .font(.caption)
                }
            }
            .padding()
        } else {
            NoDataView()
        }
    }
}
