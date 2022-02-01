//
//  NetworkController.swift
//  Forecast
//
//  Created by Arian Mohajer on 2/1/22.
//

import Foundation

class NetworkController {
    private static let baseURLString = "https://api.weatherbit.io/v2.0"
    
    static func fetchDays(completion: @escaping ([Day]?) -> Void) {
        //Step 1 - Create our base URL
        guard var baseURL = URL(string: baseURLString) else {
            //If we fail to build our base URL
            print("Unable to create URL from the provided URL: \(baseURLString.description)")
            completion(nil)
            return
        }
        
        //Step 2 - Build out our URL components
        baseURL.appendPathComponent("forecast")
        baseURL.appendPathComponent("daily")
        
        //Step 3 - Build out query parameters
        //Can't put query items right onto a URL, must put them in an array and put them on a URLComponents object
        let keyQuery = URLQueryItem(name: "key", value: "cab12b2293ff4dbe83068be7f0ded509")
        let postalCodeQuery = URLQueryItem(name: "postal_code", value: "84117")
        let unitQuery = URLQueryItem(name: "units", value: "I")
        let countryQuery = URLQueryItem(name: "country", value: "US")
        
        var urlComponents = URLComponents(url: baseURL, resolvingAgainstBaseURL: true)
        urlComponents?.queryItems = [keyQuery, postalCodeQuery, unitQuery, countryQuery]
        
        //Step 4 - Get our final URL
        guard let finalURL = urlComponents?.url else {
            print("Unable to create a final URL based off of the URL: \(urlComponents?.description)")
            completion(nil)
            return
        }
        
        //Step 5 - Create our URL session
        URLSession.shared.dataTask(with: finalURL) { data, _, error in
            
            //Step 6 - Check for the error
            if let error = error {
                print(error.localizedDescription)
                completion(nil)
            }
            
            //Step 7 - Checking for data
            guard let data = data else {
                print("No data was found")
                completion(nil)
                return
            }
            
            do {
                if let topLevelDictionary = try JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed) as? [String:Any] {
                    //Step 8 - Grab data from dictionary
                    guard let cityName = topLevelDictionary["city_name"] as? String,
                          let dataArray = topLevelDictionary["data"] as? [[String: Any]]
                    else {
                        completion(nil)
                        print(error?.localizedDescription)
                        return
                    }
                    
                    //Step 9 - Pass data into optional init
                    var tempArray: [Day] = []
                    for dayDictionary in dataArray {
                        if let day = Day(dayDictionary: dayDictionary, cityName: cityName) {
                            tempArray.append(day)
                        } else {
                            print("Failed to decode day: \(dayDictionary)")
                        }
                    }
                    
                    //Step 10 - complete with our data
                    completion(tempArray)
                }
            } catch {
                print(error.localizedDescription)
                completion(nil)
                return
            }
        }.resume()
    }
}
