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
    

    static func setVakitler(documentId: String, data: Dictionary<String, Any>, completion: @escaping firebaseCallBack){
        
        let ref = firestore.collection(documentId).document(UIDevice.current.identifierForVendor!.uuidString)
        
        ref.setData(data) { err in
            if let err = err {
                completion(true, "Success")
            } else {
                completion(true, "Failure")
            }
        }
        
        
    }
}
