//
//  CityLocation.swift
//  weatherApp
//
//  Created by Atuoha on 04/01/2025.
//


struct CityLocation: Decodable{
    let name: String
      let local_names: [String: String]
      let lon: Double
      let country: String
      let state: String
}
