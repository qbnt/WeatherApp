//
//  CurrentlyView.swift
//  weather_app
//
//  Created by Quentin Banet on 20/02/2025.
//

import SwiftUI

struct CurrentlyView: View {
    @EnvironmentObject var weatherManager: WeatherManager

    var body: some View {
        GeometryReader { geometry in
            VStack {
                if let weather = weatherManager.weatherData?.current {
                    CityData(selectedCity: weatherManager.selectedCity)
                    
                    Divider()
                    
                    Spacer()
                    if (geometry.size.width > geometry.size.height){
                        DisplayDataHorizontal(weather: weather)
                    } else {
                        DisplayData(weather: weather)
                    }
                    Spacer()
                } else {
                    NoDataView()
                }
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
        }
    }
}

#Preview {
    CurrentlyView()
        .environmentObject(WeatherManager.preview)
}
