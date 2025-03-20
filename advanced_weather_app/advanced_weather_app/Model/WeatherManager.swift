//
//  WeatherManager.swift
//  medium_weather_app
//
//  Created by Quentin Banet on 26/02/2025.
//

import Foundation
import OpenMeteoSdk

@MainActor
class WeatherManager: NSObject, ObservableObject {
    @Published var selectedCity: City
    @Published var weatherData: WeatherData?
    
    override init() {
        selectedCity = City(id: 0, name: "", latitude: 0, longitude: 0)
    }
    
    func updateSelectedCity(city: City) {
        self.selectedCity.id = city.id
        self.selectedCity.name = city.name
        self.selectedCity.admin1 = city.admin1
        self.selectedCity.country = city.country
        self.selectedCity.latitude = city.latitude
        self.selectedCity.longitude = city.longitude
    }
    
    func fetchWeather() async {
        let urlString = "https://api.open-meteo.com/v1/forecast?latitude=\(selectedCity.latitude)&longitude=\(selectedCity.longitude)&current=temperature_2m,apparent_temperature,weather_code,wind_speed_10m&hourly=temperature_2m,apparent_temperature,weather_code,wind_speed_10m&daily=weather_code,temperature_2m_max,temperature_2m_min&timezone=auto&past_days=0&forecast_days=7&format=flatbuffers"
        
        guard let url = URL(string: urlString) else {
            print("URL invalide")
            return
        }
        
        do {
            let responses = try await WeatherApiResponse.fetch(url: url)
            guard let response = responses.first else {
                print("Aucune réponse météo reçue")
                return
            }
            
            // Récupère des attributs utiles pour le traitement
            let utcOffsetSeconds = response.utcOffsetSeconds
    
            let current = response.current!
            let hourly = response.hourly!
            let daily = response.daily!
            
            let data = WeatherData(
                utcOffsetSeconds: Int(utcOffsetSeconds),
                current: .init(
                    time: Date(timeIntervalSince1970: TimeInterval(current.time + Int64(utcOffsetSeconds))),
                    temperature2m: current.variables(at: 0)!.value,
                    apparentTemperature: current.variables(at: 1)!.value,
                    weatherCode: current.variables(at: 2)!.value,
                    windSpeed10m: current.variables(at: 3)!.value
                ),
                hourly: .init(
                    time: hourly.getDateTime(offset: utcOffsetSeconds),
                    temperature2m: hourly.variables(at: 0)!.values,
                    apparentTemperature: hourly.variables(at: 1)!.values,
                    weatherCode: hourly.variables(at: 2)!.values,
                    windSpeed10m: hourly.variables(at: 3)!.values
                ),
                daily: .init(
                    time: daily.getDateTime(offset: utcOffsetSeconds),
                    weatherCode: daily.variables(at: 0)!.values,
                    temperature2mMax: daily.variables(at: 1)!.values,
                    temperature2mMin: daily.variables(at: 2)!.values
                )
            )
            
            DispatchQueue.main.async { [self] in
                weatherData = data
            }
            
        } catch {
            print("Erreur lors de la récupération des données météo : \(error)")
        }
    }
}

extension WeatherManager {
    static var preview: WeatherManager {
        let manager = WeatherManager()
        
        manager.selectedCity = City(
            id: 42,
            name: "Sample",
            latitude: 42.6886,
            longitude: 2.8948,
            admin1: "Sample",
            country: "Sample"
        )

        manager.weatherData = WeatherData(
            utcOffsetSeconds: 3600,
            current: WeatherData.Current(
                time: Date(),
                temperature2m: 15.0,
                apparentTemperature: 15.0,
                weatherCode: 1,
                windSpeed10m: 8.0
            ),
            hourly: WeatherData.Hourly(
                time: (0..<24).compactMap { Calendar.current.date(byAdding: .hour, value: $0, to: Calendar.current.startOfDay(for: Date())) },
                temperature2m: (0..<24).map { _ in Float.random(in: 10...20) },
                apparentTemperature: (0..<24).map { _ in Float.random(in: 10...20) },
                weatherCode: (0..<24).map { _ in Float(Int.random(in: 1...3)) },
                windSpeed10m: (0..<24).map { _ in Float.random(in: 5...15) }
            ),
            daily: WeatherData.Daily(
                time: (0..<7).compactMap { Calendar.current.date(byAdding: .day, value: $0, to: Date()) },
                weatherCode: (0..<7).map { _ in Float(Int.random(in: 1...3)) },
                temperature2mMax: (0..<7).map { _ in Float.random(in: 15...25) },
                temperature2mMin: (0..<7).map { _ in Float.random(in: 5...15) }
            )
        )

        return manager
    }
}

// Réponses API - Recherche par nom de ville
struct GeocodingResponse: Codable {
    let results: [City]
    let generationtime_ms: Double?
}

struct City: Identifiable, Codable {
    var id: Int
    var name: String
    var latitude: Double
    var longitude: Double
    var admin1: String?
    var country: String?
    
    mutating func delete() {
        self.id = 0
        self.name = ""
        self.latitude = 0
        self.longitude = 0
        self.admin1 = nil
        self.country = nil
    }
}

// Réponse API - Météo

struct WeatherData: Codable {
    let utcOffsetSeconds: Int

    let current: Current

    let hourly: Hourly

    let daily: Daily

    struct Current : Codable {
        let time: Date
        let temperature2m: Float
        let apparentTemperature: Float
        let weatherCode: Float
        let windSpeed10m: Float
        
        var weatherCondition: WeatherCondition {
            return WeatherCondition(code: weatherCode)
        }
    }

    struct Hourly : Codable {
        let time: [Date]
        let temperature2m: [Float]
        let apparentTemperature: [Float]
        let weatherCode: [Float]
        let windSpeed10m: [Float]
    }

    struct Daily : Codable {
        let time: [Date]
        let weatherCode: [Float]
        let temperature2mMax: [Float]
        let temperature2mMin: [Float]
    }
}
