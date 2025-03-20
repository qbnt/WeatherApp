//
//  SearchBarView.swift
//  medium_weather_app
//
//  Created by Quentin Banet on 27/02/2025.
//

import SwiftUI

struct SearchBarView: View {
    @FocusState.Binding var isFocused: Bool
    @Binding var searchText: String
    @Binding var citySuggestions: [City]

    var body: some View {
        TextField("Search a city ...", text: $searchText)
            .padding(10)
            .background(Color.white)
            .cornerRadius(8)
            .focused($isFocused)
            .onChange(of: searchText) {
                if searchText.count > 2 {
                    updateCitySuggestions(query: searchText)
                }
            }
    }
    
    func updateCitySuggestions(query: String) {
        guard !query.isEmpty else {
            citySuggestions = []
            return
        }

        searchCity(query: query) { results in
            self.citySuggestions = results
        }
    }
    
    func searchCity(query: String, completion: @escaping ([City]) -> Void) {
        guard let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }
        
        let urlString = "https://geocoding-api.open-meteo.com/v1/search?name=\(encodedQuery)&count=5&language=fr&format=json"
        
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("❌ Erreur API : \(error.localizedDescription)")
                return
            }
            
            guard let data = data else { return }
            
            do {
                let decodedResponse = try JSONDecoder().decode(GeocodingResponse.self, from: data)
                DispatchQueue.main.async {
                    completion(decodedResponse.results)
                }
            } catch {
                print("❌ Erreur de décodage JSON : \(error.localizedDescription)")
            }
        }.resume()
    }
}

#Preview {
    @Previewable @State var searchText: String = ""
    @Previewable @State var citySuggestions: [City] = []
    @FocusState var isFocused: Bool

    return SearchBarView(isFocused: $isFocused, searchText: $searchText, citySuggestions: $citySuggestions)
}
