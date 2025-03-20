//
//  NoDataView.swift
//  medium_weather_app
//
//  Created by Quentin Banet on 04/03/2025.
//

import SwiftUI

struct NoDataView: View {
    @EnvironmentObject var locationManager: LocationManager
    var body: some View {
        VStack {
            if locationManager.isLoadingPositon == false {
                Text("Aucune donnée météo disponible")
                    .font(.headline)
                    .foregroundColor(.gray)
                    .padding()
            } else {
                ProgressView("Chargement...")
                    .font(.title)
                    .progressViewStyle(CircularProgressViewStyle())
                    .padding()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    NoDataView()
}
