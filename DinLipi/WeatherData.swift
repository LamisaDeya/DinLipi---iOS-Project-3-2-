//
//  WeatherData.swift
//  DinLipi
//
//  Created by IQBAL MAHAMUD on 11/11/23.
//

import Foundation
struct WeatherData:Codable
{
    let location:LocationData
    let current:CurrentData
}
