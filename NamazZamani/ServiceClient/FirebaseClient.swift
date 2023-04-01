//
//  FirebaseClient.swift
//  NamazVakitleri
//
//  Created by Süha Karakaya on 17.02.2022.
//

import Foundation
import Firebase
import Alamofire
import FirebaseDatabase

public class FirebaseClient {
    
    static fileprivate var firestore = Firestore.firestore()
    static fileprivate var ref = Database.database().reference()
    
    typealias firebaseGetCallBack = (Bool, String, [String:Any]) -> Void
    typealias firebaseGetCallBackList = (Bool, String, [FirebaseResponse]) -> Void
    typealias firebaseSetCallBack = (Bool, String) -> Void
    
    static func setDocRefData(_ documentName: String, _ tableName: String, _  data: [String:Any], completion: @escaping firebaseSetCallBack){
        
        let ref = firestore.collection(tableName).document(documentName)
        ref.setData(data) { err in
            if err != nil  {
                completion(false, "Failure")
            } else {
                completion(true, "Success")
            }
        }
        
        
    }
    
    static func setAllData(_ tableName: String, _ data: [String:Any], completion: @escaping firebaseSetCallBack){
        
        let ref = firestore.collection(tableName)
        var ref1: DocumentReference? = nil
        ref1 = ref.addDocument(data: data) { err in
            if err != nil {
                completion(false, "Failure")
            } else {
                completion(true, ref1?.documentID ?? "")
            }
        }
        
    }
    
    static func setVakitData(_ documentId: String, _ tableName: String, _ data: LocationDetail, completion: @escaping firebaseSetCallBack) {
        if documentId == "" {
            setAllData(tableName, data.toJSON()) { result, status in
                completion(result, status)
            }
        } else {
            setDocRefData(documentId, tableName, data.toJSON()) { result, status in
                completion(result, status)
            }
        }
        
    }
    
    
    static func setVakitList(_ tableName: String, _ data: [Vakit], _ location: String, completion: @escaping firebaseSetCallBack){
        
        let ref = firestore.collection(tableName)
        var ref1: DocumentReference? = nil
        let docData: [String: Any] = [
            "location": location,
            "vakitList": data.toJSON()
        ]
        ref1 = ref.addDocument(data: docData) { err in
            if err != nil {
                completion(false, "Failure")
            } else {
                completion(true, ref1?.documentID ?? "")
            }
        }
        
    }
    
    static func setVakitListRef(_ documentName: String, _ tableName: String, _  data: [Vakit], _ location: String, completion: @escaping firebaseSetCallBack){
        
        let ref = firestore.collection(tableName).document(documentName)
        let docData: [String: Any] = [
            "location": location,
            "vakitList": data.toJSON()
        ]
        ref.setData(docData) { err in
            if err != nil  {
                completion(false, "Failure")
            } else {
                completion(true, "Success")
            }
        }
        
        
    }
    //    yorum
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
    
    static func getDocTwoWhereCondt(_ collectionName: String, _ whereField1: String, _ whereCondition1: Any, _ whereField2: String, _ whereCondition2: Any, completion: @escaping firebaseGetCallBackList){
        firestore.collection(collectionName).whereField(whereField1, isEqualTo: whereCondition1).whereField(whereField2, isEqualTo: whereCondition2)
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
    
    static func updateBool(_ collectionName: String, _ documentId: String, _ myWhere:String, _ updateData: Bool, completion: @escaping firebaseSetCallBack){
        firestore.collection(collectionName).document(documentId).updateData([
            myWhere:updateData
        ]) { err in
            if err != nil {
                completion(false, "Failure")
            } else {
                completion(true, "Success")
            }
        }
        
        
    }
    
    static func updateString(_ collectionName: String, _ documentId: String, _ myWhere:String, _ updateData: String, completion: @escaping firebaseSetCallBack){
        firestore.collection(collectionName).document(documentId).updateData([
            myWhere:updateData
        ]) { err in
            if err != nil {
                completion(false, "Failure")
            } else {
                completion(true, "Success")
            }
        }
        
    }
    
    static func delete(_ collectionName: String, _ documentId: String, completion: @escaping firebaseSetCallBack){
        firestore.collection(collectionName).document(documentId).delete() { err in
            if err != nil {
                completion(false, "Failure")
            } else {
                completion(true, "Success")
            }
        }
    }
    
    static func update(_ collectionName: String, _ documentName: String, _ data: [[String:Any]], completion: @escaping firebaseSetCallBack){
        firestore.collection(collectionName).document(documentName).updateData([
            "locationList": data
        ]) { err in
            if err != nil {
                completion(false, "Failure")
            } else {
                completion(true, "Success")
            }
        }
    }
    
    static func getCurrentVersion(completion: @escaping (String, Int) -> Void) {
        ref.child("vsInfo").observe(.value) { snapshot in
            let value = snapshot.value as? NSDictionary
            let version = value?["version"] as? String ?? ""
            let build = value?["build"] as? Int ?? 0
            completion(version, build)
        } withCancel: { error in
            debugPrint(error.localizedDescription)
            completion("", 0)
        }
    }
    
    
}
struct vsInfo: Codable {
    let version: Int
    let build: Int
}
