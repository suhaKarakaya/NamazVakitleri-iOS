//
//  Country.swift
//  NamazVakitleri
//
//  Created by Süha Karakaya on 16.02.2022.
//

import Foundation

struct Country: Codable {
    let UlkeAdi: String?
    let UlkeAdiEn: String?
    let UlkeID: String?
}

struct City: Codable {
    let SehirAdi: String?
    let SehirAdiEn: String?
    let SehirID: String?
}

struct District: Codable {
    let IlceAdi: String?
    let IlceAdiEn: String?
    let IlceID: String?
}

struct Vakit: Codable {
    let Aksam: String?
    let AyinSekliURL: String?
    let Gunes: String?
    let GunesBatis: String?
    let GunesDogus: String?
    let HicriTarihKisav: String?
    let HicriTarihKisaIso8601: String?
    let HicriTarihUzun: String?
    let HicriTarihUzunIso8601: String?
    let Ikindi: String?
    let Imsak: String?
    let KibleSaati: String?
    let MiladiTarihKisa: String?
    let MiladiTarihKisaIso8601: String?
    let MiladiTarihUzun: String?
    let MiladiTarihUzunIso8601: String?
    let Ogle: String?
    let Yatsi: String?
}

