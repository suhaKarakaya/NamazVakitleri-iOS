//
//  ServiceManager.swift
//  NamazVakitleri
//
//  Created by Süha Karakaya on 3.01.2023.
//

import Foundation
import Alamofire

final class ServiceManager {
    static let shared: ServiceManager = ServiceManager()
}

extension ServiceManager {
    func fetch<T>(path: String, onSuccess: @escaping (T) -> (), onError: @escaping (AFError) -> ()) where T: Codable {
        AF.request(path, encoding: JSONEncoding.default).validate().responseDecodable(of : T.self) { response in
            guard let model = response.value else {print(response.error as? Any); return }
            onSuccess(model)
        }
    }
}
