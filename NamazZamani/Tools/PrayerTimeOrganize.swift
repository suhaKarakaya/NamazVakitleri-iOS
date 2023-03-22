//
//  PrayerTimeOrganize.swift
//  NamazZamani
//
//  Created by Süha Karakaya on 18.03.2023.
//

import Foundation
import ObjectMapper


class PrayerTimeOrganize {
    
    //    Kullanıcının device id bilgisine göre sistemdeki konumları çekilir
    static func getFirebaseUserData(selectCountry: SelectObje, selectCity: SelectObje, selectDistrict: SelectObje, uniqName: String,  completion: @escaping (LocationDetail, Bool) -> Void) {
        FirebaseClient.getDocWhereCondt("UserInfo", "deviceId", FirstSelectViewController.deviceId) { result, status, response in
            //            kullanıcının sisteme daha önce kayıt oluşturduğu lokasyonlar var
            if result {
                guard let tempObj = Mapper<UserInfo>().map(JSON:  response[0].document) else { return }
                vakitControl(selectCountry: selectCountry, selectCity: selectCity, selectDistrict: selectDistrict, documentId: response[0].documentId, uniqName: uniqName, locList: tempObj.locationList) { data, status in
                    if status { completion(data, true) }
                }
            }
            //            kullanıcının sisteme daha önce kayıt oluşturduğu lokasyonlar yok(kullanıcım sıfır kullanıcı)
            else {
                vakitControl(selectCountry: selectCountry, selectCity: selectCity, selectDistrict: selectDistrict, documentId: "", uniqName: uniqName, locList: []) { data, status in
                    if status { completion(data, true) }
                }
            }
        }
    }
    
    private static func setFirebaseVakitList(selectCountry: SelectObje, selectCity: SelectObje, selectDistrict: SelectObje, documentId: String, uniqName: String, vakitList: [Vakit], completion: @escaping (LocationDetail, Bool) -> Void) {
        let data = LocationDetail()
        data.uniqName = uniqName
        data.lastUpdateTime = DateManager.dateToStringUgur(date: Date())
        data.districtId = selectDistrict.strId
        data.districtName = selectDistrict.value
        data.cityId = selectCity.strId
        data.cityName = selectCity.value
        data.countryId = selectCountry.strId
        data.countyName = selectCountry.value
        data.vakitList = vakitList
        
        FirebaseClient.setVakitData(documentId, "Vakits", data) { result, status in
            if result { completion(data, result) }
        }
        
    }
    
    private static func setFirebaseUserInfoData(documentId: String, uniqName: String, list: [UserLocationList], completion: @escaping (Bool) -> Void) {
        if !list.isEmpty { list.forEach({ $0.isFavorite = false }) }
        let userLocation = UserLocationList()
        userLocation.isFavorite = true
        userLocation.uniqName = uniqName
        var userLocationList: [UserLocationList] = list
        userLocationList.append(userLocation)
        let tempData: [String: Any] = [
            "deviceModel": FirstSelectViewController.deviceModel,
            "deviceId": FirstSelectViewController.deviceId,
            "locationList": userLocationList.toJSON()
        ]
        if documentId == "" {
            FirebaseClient.setAllData("UserInfo", tempData) { result, status in
                completion(result)
            }
        } else {
            FirebaseClient.setDocRefData(documentId, "UserInfo", tempData) { result, status in
                completion(result)
            }
        }
        
    }
    
    private static func vakitControl(selectCountry: SelectObje, selectCity: SelectObje, selectDistrict: SelectObje, documentId: String, uniqName: String, locList: [UserLocationList], completion: @escaping (LocationDetail, Bool) -> Void) {
        FirebaseClient.getDocWhereCondt("Vakits", "uniqName", uniqName) { result, status, response in
            //                    Kullanıcının belirtmiş olduğu lokasyon sistemde var
            if result {
                guard let vakitData = Mapper<LocationDetail>().map(JSON: response[0].document) else { return }
                let lastUpdateTimeDate = DateManager.strToDateUgur(strDate: vakitData.lastUpdateTime)
                let temp = DateManager.checkDate(date: Date(), endDate: lastUpdateTimeDate)
                if temp == .orderedAscending {
                    //                  geride kalmış yeni zaman çek
                    getApiandSetFirebase(selectCountry: selectCountry, selectCity: selectCity, selectDistrict: selectDistrict, vakitDocumentId: response[0].documentId, userDocumentId: documentId, uniqName: uniqName, locList: locList) { data, status in
                        if status {completion(data, true)}
                    }
                }
                else {
                    setFirebaseUserInfoData(documentId: documentId, uniqName: uniqName, list: locList) { result in
                        if result { completion(vakitData, true) }
                    }
                }
            }
            //                    kullanıcının belitmiş olduğu lokasyon sistemde yok
            else {
                getApiandSetFirebase(selectCountry: selectCountry, selectCity: selectCity, selectDistrict: selectDistrict, vakitDocumentId: "", userDocumentId: documentId, uniqName: uniqName, locList: locList) { data, status in
                    if status {completion(data, true)}
                }
            }
        }
    }
    
    private static func getApiandSetFirebase(selectCountry: SelectObje, selectCity: SelectObje, selectDistrict: SelectObje, vakitDocumentId: String ,userDocumentId: String,  uniqName: String, locList: [UserLocationList], completion: @escaping (LocationDetail, Bool) -> Void ) {
        ApiClient.shared.fetchPrayerTime(districtId: selectDistrict.strId) { responseVakitList, result, status in
            //                    apiden servis başarılı döndü
            if result {
                guard let responseList = responseVakitList else { return }
                //                        bu lokasyondaki vakit değerleri daha önce sisteme kayıt edilmemiş, kayıt edilmeli
                setFirebaseVakitList(selectCountry: selectCountry, selectCity: selectCity, selectDistrict: selectDistrict, documentId: vakitDocumentId, uniqName: uniqName, vakitList: responseList) { data, result in
                    if result {
                        setFirebaseUserInfoData(documentId: userDocumentId, uniqName: uniqName, list: locList) { result in
                            if result { completion( data, true) }
                        }
                    }
                }
            }
            //                    apiden servis başarısız döndü
            else {
                
            }
        }
    }
    
    
    static func getMyLocationData(completion: @escaping (LocationDetail, Bool) -> Void) {
        FirebaseClient.getDocWhereCondt("UserInfo", "deviceId", FirstSelectViewController.deviceId) { result, status, response in
            if result {
                guard let tempObj = Mapper<UserInfo>().map(JSON:  response[0].document) else { return }
                var favLoc = tempObj.locationList.filter { $0.isFavorite }
                FirebaseClient.getDocWhereCondt("Vakits", "uniqName", favLoc[0].uniqName) { result, status, response in
                    if result {
                        guard let tempObj = Mapper<LocationDetail>().map(JSON:  response[0].document) else { return }
                        completion(tempObj, true)
                    }
                }
            } else {
                completion(LocationDetail(), false)
            }
        }
    }
    
    
}
