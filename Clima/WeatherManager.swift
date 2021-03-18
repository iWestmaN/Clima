//
//  WeatherManager.swift
//  Clima
//
//  Created by Igor Lishchenko on 07.12.2020.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation


protocol WeatherUpdateDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel)
    func didFailWithError(error: Error)
}
struct WeatherManager {
    var delegate: WeatherUpdateDelegate?
    
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=aecd6ab68e7cc3d5e7695a4bec3d144d&units=metric"
    
    func fetchWeather(cityName: String) {
        let urlString = "\(weatherURL)&q=\(cityName)"
        preformRequest(with: urlString)
       // print(urlString)
        
    }
    func fetchWeather(latitude: Double , longitude: Double) {
        let urlString = "\(weatherURL)&lat=\(latitude)&lon=\(longitude)"
        preformRequest(with: urlString)
       // print(urlString)
        
    }
    func preformRequest(with urlString: String){
            // Creat URL
        if let url = URL(string: urlString) {
            // Creat URLSession
            let session = URLSession(configuration: .default)
            
            // Give the session a task
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                if let safeData = data {
                    //                    let stringData = String(data: safeData, encoding: .utf8)
                    //                    print(stringData)
                    if let weather = self.parseJSON(safeData) {
                        self.delegate?.didUpdateWeather(self, weather: weather)
                    }
                }
            }
            //  Start task
            task.resume()
        }
        
        
    }
    func parseJSON(_ weatherData: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            let conditionID = decodedData.weather[0].id
            let cityName = decodedData.name
            let temp = decodedData.main.temp
            
            let weather = WeatherModel(conditionID: conditionID, CityName: cityName, temperature: temp)
            print(weather.temperatureString)
            return weather
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
    
 
    
    
}
