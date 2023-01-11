//
//  Country.swift
//  NamazVakitleri
//
//  Created by Süha Karakaya on 16.02.2022.
//

import Foundation
import ObjectMapper

struct Country: Codable {
    let UlkeAdi: String?
    let UlkeAdiEn: String?
    let UlkeID: String?
}

struct City: Codable {
    let sehirAdi: String?
    let sehirAdiEn: String?
    let sehirID: String?
    let SehirAdi: String?
    let SehirAdiEn: String?
    let SehirID: String?
}

struct District: Codable {
    let IlceAdi: String?
    let IlceAdiEn: String?
    let IlceID: String?
}
