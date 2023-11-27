//
//  CurrentData.swift
//  DinLipi
//
//  Created by IQBAL MAHAMUD on 11/11/23.
//

import Foundation
struct CurrentData:Codable
{
    let last_updated:String
    let temp_c:Float
    let wind_kph:Float
    let humidity:Int
    let is_day:Int
    let feelslike_c:Decimal
    let pressure_in:Decimal
    let precip_in:Decimal
    let cloud:Int
    let uv:Decimal
}
