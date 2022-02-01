//
//  Day.swift
//  Forecast
//
//  Created by Arian Mohajer on 2/1/22.
//

import Foundation

class Day {
    let currentTemp: Double
    let date: String
    let iconString: String
    let weatherDescription: String
    let hTemp: Double
    let lTemp: Double
    let cityName: String
    
    init?(dayDictionary: [String:Any], cityName: String) {
        
        guard let currentTemp = dayDictionary["temp"] as? Double,
              let date = dayDictionary["valid_date"] as? String,
              let weather = dayDictionary["weather"] as? [String:Any],
              let iconString = weather["icon"] as? String,
              let hTemp = dayDictionary["high_temp"] as? Double,
              let lTemp = dayDictionary["low_temp"] as? Double,
              let weatherDescription = weather["description"] as? String else { return nil }
        
        self.currentTemp = currentTemp
        self.date = date
        self.iconString = iconString
        self.weatherDescription = weatherDescription
        self.hTemp = hTemp
        self.lTemp = lTemp
        self.cityName = cityName
    }
}
