//
//  WeeklyView.swift
//  weather_app
//
//  Created by Quentin Banet on 20/02/2025.
//

import SwiftUI

struct WeeklyView: View {
    @EnvironmentObject var weatherManager: WeatherManager

    var body: some View {
        GeometryReader { geometry in
            VStack {
                if let dailyWeather = weatherManager.weatherData?.daily {
                    
                    CityData(selectedCity: weatherManager.selectedCity)
                    
                    Divider()
                    
                    Spacer()
                    VStack() {
                        if ((UIDevice.current.userInterfaceIdiom == .phone) && geometry.size.width < geometry.size.height || !(UIDevice.current.userInterfaceIdiom == .phone)) {
                            WeekGraphView(dailyWeather: dailyWeather)
                                .padding(.horizontal)
                        }
                        WeekScrollData(dailyWeather: dailyWeather)
                            .padding(.bottom, 8)
                    }
                    Spacer()
                } else {
                    NoDataView()
                }
            }
        }
    }
}

#Preview {
    WeeklyView()
}
