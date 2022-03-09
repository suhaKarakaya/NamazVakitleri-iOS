//
//  FirebaseClient.swift
//  NamazVakitleri
//
//  Created by Süha Karakaya on 17.02.2022.
//

import Foundation
import Firebase

public class FirebaseClient {
    
    static fileprivate var firestore = Firestore.firestore()
    typealias firebaseCallBack = (Bool, String) -> Void
    

    static func setVakitler(documentName: String, tableName: String, data: [String:Any], completion: @escaping firebaseCallBack){
        
        let ref = firestore.collection(tableName).document(documentName)
        
        ref.setData(data) { err in
            if let err = err {
                completion(false, "Failure")
            } else {
                completion(true, "Success")
            }
        }
        
        
    }
}
