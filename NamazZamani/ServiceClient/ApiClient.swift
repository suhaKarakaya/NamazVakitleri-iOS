//
//  ApiClient.swift
//  NamazVakitleri
//
//  Created by Süha Karakaya on 17.02.2022.
//

import Foundation
import Alamofire
import ObjectMapper

typealias countryCallBack = ([Country]?, Bool, String) -> Void
fileprivate var baseUrl = "https://ezanvakti.herokuapp.com/"
typealias cityCallBack = ([City]?, Bool, String) -> Void
typealias districtCallBack = ([District]?, Bool, String) -> Void
typealias vakitlerCallBack2 = ([[String]]?, Bool, String) -> Void
typealias vakitlerCallBack = ([Vakit]?, Bool, String) -> Void
typealias errorHandler = (AFError) -> Void

protocol ApiClientProtocol {
    //    func fetchCountry(onSuccess: @escaping([Country]?) -> (), onError: @escaping(AFError) -> ())
    //    func fetchCountry(completion: @escaping countryCallBack, onError: errorHandler)
    func fetchCountry(completion: @escaping countryCallBack)
    func fetchCity(countyId: String, completion: @escaping cityCallBack)
    func fetchDistrict(countyId: String, cityId: String, completion: @escaping districtCallBack)
    func fetchPrayerTime(districtId: String, completion: @escaping vakitlerCallBack)
}

public class ApiClient:ApiClientProtocol {
    
    static let shared: ApiClient = ApiClient()
}

extension ApiClient {
    
    func fetchCountry(completion: @escaping countryCallBack) {
        ServiceManager.shared.fetch(path: String(format: "%@%@", baseUrl, "ulkeler")) { (response: [Country]) in
            completion(response, true, "Success")
        } onError: { error in
            completion([], false, "Failure")
        }
    }
    
    func fetchCity(countyId: String, completion: @escaping cityCallBack) {
        ServiceManager.shared.fetch(path: String(format: "%@%@/%@", baseUrl, "sehirler", countyId)) { (response: [City]) in
            completion(response, true, "Success")
        } onError: { error in
            completion([], false, "Failure")
        }
    }
    
    func fetchDistrict(countyId: String, cityId: String, completion: @escaping districtCallBack) {
        ServiceManager.shared.fetch(path: String(format: "%@%@/%@", baseUrl, "ilceler", cityId)) { (response: [District]) in
            completion(response, true, "Success")
        } onError: { error in
            completion([], false, "Failure")
        }
    }
    
    func fetchPrayerTime(districtId: String, completion: @escaping vakitlerCallBack) {
        ServiceManager.shared.fetch(path: String(String(format: "%@%@/%@", baseUrl, "vakitler", districtId))) { (response: [Vakit]) in
            completion(response, true, "Success")
        } onError: { error in
            completion([], false, "Failure")
        }
    }
}
