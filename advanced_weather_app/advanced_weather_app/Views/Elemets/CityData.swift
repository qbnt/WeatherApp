//
//  CityData.swift
//  medium_weather_app
//
//  Created by Quentin Banet on 04/03/2025.
//

import SwiftUI

struct CityData: View {
    var selectedCity: City
    var body: some View {
        VStack {
            Text(selectedCity.name)
                .font(.title)
            
            if let admin1 = selectedCity.admin1,
               let country = selectedCity.country {
                Text("\(admin1) - \(country)")
                    .font(.subheadline)
            } else if let country = selectedCity.country {
                Text(country)
                    .font(.subheadline)
            }
        }
        .padding(.top, 30)
    }
}
