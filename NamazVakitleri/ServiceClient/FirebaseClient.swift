//
//  FirebaseClient.swift
//  NamazVakitleri
//
//  Created by Süha Karakaya on 17.02.2022.
//

import Foundation
import Firebase
import Alamofire

public class FirebaseClient {
    
    static fileprivate var firestore = Firestore.firestore()

    typealias firebaseGetCallBack = (Bool, String, [String:Any]) -> Void
    typealias firebaseGetCallBackList = (Bool, String, [FirebaseResponse]) -> Void
    typealias firebaseSetCallBack = (Bool, String) -> Void
    
    static func setDocRefData(_ documentName: String, _ tableName: String, _  data: [String:Any], completion: @escaping firebaseSetCallBack){
        
        let ref = firestore.collection(tableName).document(documentName)
        ref.setData(data) { err in
            if let err = err {
                completion(false, "Failure")
            } else {
                completion(true, "Success")
            }
        }
        
        
    }
    
    static func setAllData(_ tableName: String, _ data: [String:Any], completion: @escaping firebaseSetCallBack){
        
        let ref = firestore.collection(tableName)
        
        ref.addDocument(data: data).addSnapshotListener { snap, err in
            if let err = err {
                completion(false, "Failure")
            } else {
                completion(true, snap?.documentID ?? "")
            }
        }
        
        

        
    }
    
    static func getDocRefData(_ collectionName: String, _ documentName: String, completion: @escaping firebaseGetCallBack){
        
        let docRef = firestore.collection(collectionName).document(documentName)
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                completion(true, document.documentID, document.data() ?? ["":""])
            } else {
                completion(false, "Failure", ["":""])
            }
        }
    }
    
    static func getAllData(_ collectionName: String, completion: @escaping firebaseGetCallBack){
        
        firestore.collection(collectionName).getDocuments { (snapshot, error) in
                 if let error = error {
                     print(error.localizedDescription)
                 } else {
                     if let snapshot = snapshot {
                         for document in snapshot.documents {
                             completion(true, document.documentID, document.data())
                         }
                     } else {
                         completion(false, "Failure", ["":""])
                     }
                 }
             }
    }
    
    static func getDocWhereCondt(_ collectionName: String, _ whereField: String, _ whereCondition: Any, completion: @escaping firebaseGetCallBackList){
        firestore.collection(collectionName).whereField(whereField, isEqualTo: whereCondition)
            .getDocuments() { (querySnapshot, err) in
                if err != nil {
                    completion(false, "Failure", [])
                    
                } else {
                    var tempDict: [FirebaseResponse] = []
                    if querySnapshot!.documents.isEmpty {
                        completion(false, "Failure", [])
                    } else {
                        for document in querySnapshot!.documents {
                            let tempObj = FirebaseResponse()
                            tempObj.document = document.data()
                            tempObj.documentId = document.documentID
                            tempDict.append(tempObj)
                        }
                        completion(true, "Success", tempDict)
                    }
                   
                    
                }
                
            }
        
    }

}
