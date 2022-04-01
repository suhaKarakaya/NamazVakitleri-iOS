//
//  ApiClient.swift
//  NamazVakitleri
//
//  Created by Süha Karakaya on 17.02.2022.
//

import Foundation
import Alamofire
import ObjectMapper

public class ApiClient {

    static fileprivate var baseUrl = "https://namaz-vakti-api.herokuapp.com/"
    typealias countryCallBack = ([Country]?, Bool, String) -> Void
    typealias cityCallBack = ([City]?, Bool, String) -> Void
    typealias districtCallBack = ([District]?, Bool, String) -> Void
    typealias vakitlerCallBack = ([[String]]?, Bool, String) -> Void
 
    
    static func getCountry(completion: @escaping countryCallBack){
        AF.request(baseUrl + "countries", method: .get, encoding: URLEncoding.default, headers: nil, interceptor: nil).response { (responseData) in
            
            guard let data = responseData.data else { return }
            
            do{
                let data = try JSONDecoder().decode([Country].self, from: data)
                completion(data, true, "Success")
            } catch {
                completion([], false, "Failure")
            }
            
        }
    }

    
    static func getCity(countyId: String, completion: @escaping cityCallBack){
        var param:[String:Any] = [:]
        param["country"] = countyId
        
        AF.request(String(format: "%@%@", baseUrl, "cities"),
//            String(format: "%@%@/%@", baseUrl, "country", countyId),
            method: .get,
                   parameters: param,
                   encoding: URLEncoding.default, headers: nil, interceptor: nil).response { (responseData) in
                
//            debugPrint(String(format: "%@%@/%@", baseUrl, "sehirler", countyId))
            
            guard let data = responseData.data else { return }
            
            do{
                let data = try JSONDecoder().decode([City].self, from: data)
                completion(data, true, "Success")
            } catch {
                completion([], false, "Failure")
            }
            
        }
    }
    
    static func getDistrict(countyId: String, cityId: String, completion: @escaping districtCallBack){
        var param:[String:Any] = [:]
        param["country"] = countyId
        param["city"] = cityId
        AF.request(
            String(format: "%@%@", baseUrl, "regions"), method: .get,
                   parameters: param,
                   encoding: URLEncoding.default, headers: nil, interceptor: nil).response { (responseData) in
            
            guard let data = responseData.data else { return }
            
            do{
                let data = try JSONDecoder().decode([District].self, from: data)
                completion(data, true, "Success")
            } catch {
                completion([], false, "Failure")
            }
            
        }
    }
    
    static func getVakitler(districtId: String, completion: @escaping vakitlerCallBack){
        var param:[String:Any] = [:]
        param["region"] = districtId
        AF.request(String(format: "%@%@", baseUrl, "data"), method: .get,parameters: param, encoding: URLEncoding.default, headers: nil, interceptor: nil).response { (responseData) in
            
//            debugPrint(String(format: "%@%@/%@", baseUrl, "vakitler", districtId))
            
            guard let data = responseData.data else { return }
            
     
            
            do{
                let data = try JSONDecoder().decode([[String]].self, from: data)
//                var arr: [Vakit] = []
//                data.forEach { (value) in
//                if let record = Mapper<Vakit>().map(JSON: value as? [String: Any] ?? [:]) {
//                    arr.append(record)
//                    }
//                }
                
                
                completion(data, true, "Success")
            } catch {
                completion([], false, "Failure")
            }
            
        }
    }
    
}
