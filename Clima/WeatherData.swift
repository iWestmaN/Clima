//
//  WeatherData.swift
//  Clima
//
//  Created by Igor Lishchenko on 07.12.2020.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation

struct WeatherData: Decodable {
    let name: String
    let main: Main
    let weather: [Weather]
}
struct Main: Decodable {
    let temp: Double
    let feels_like: Double
}
struct Weather: Decodable {
    let description: String
    let id: Int
}
