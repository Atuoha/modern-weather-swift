//
//  WeatherInfo.swift
//  weatherApp
//
//  Created by Atuoha on 27/12/2024.
//

struct WeatherInfo: Decodable{
    var clouds: Clouds;
    var dt: Int;
    var dt_txt: String;
    var main: Main;
    var pop: Double;
    var sys: Sys;
    var visibility: Int;
    var weather: [WeatherX];
    var wind: Wind
}
