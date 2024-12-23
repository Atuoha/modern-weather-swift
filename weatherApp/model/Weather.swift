//
//  Weather.swift
//  weatherApp
//
//  Created by Atuoha on 27/12/2024.
//

struct Weather: Decodable{
    var city: City;
    var cnt: Int;
    var cod: String;
    var list: [WeatherInfo];
    var message: Int
}

