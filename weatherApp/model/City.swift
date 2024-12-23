//
//  City.swift
//  weatherApp
//
//  Created by Atuoha on 27/12/2024.
//

struct City: Decodable{
    var coord: Coord;
    var country: String;
    var id: Int;
    var name: String;
    var population: Int;
    var sunrise: Int;
    var sunset: Int;
    var timezone: Int
}
