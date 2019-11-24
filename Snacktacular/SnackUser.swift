//
//  SnackUser.swift
//  Snacktacular
//
//  Created by Kim-An Quinn on 11/24/19.
//  Copyright © 2019 John Gallaugher. All rights reserved.
//

import Foundation
import Firebase

class SnackUser{
    var email: String
    var displayName: String
    var photoURL: String
    var userSince: Date
    var documentID: String
    
    var dictionary: [String: Any]{
        return["email": email, "displayName": displayName, "photoURL": photoURL, "userSince": userSince, "documentID": documentID]
    }
    
    init(email: String, displayName: String, photoURL: String, userSince: Date, documentID: String){
        self.email = email
        self.displayName = displayName
        self.photoURL = photoURL
        self.userSince = userSince
        self.documentID = documentID
    }
    
    convenience init(user: User) {
        self.init(email: user.email ?? "", displayName: user.displayName ?? "", photoURL: (user.photoURL != nil ? "\(user.photoURL!)" : ""), userSince: Date(), documentID: user.uid)
    }
    
    func saveIfNewUser(){
        let db = Firestore.firestore()
        let userRef = db.collection("users").document(documentID)
        userRef.getDocument { (document, error) in
            guard error == nil else{
                print("😬 error: could not access document for user")
                return
            }
            guard document?.exists == false else{
                print("**** the document for user \(self.documentID) already exists no reason to create")
                return
            }
            self.saveData()
        }
    }
    
    func saveData(){
        let db = Firestore.firestore()
        let dataToSave: [String: Any] = self.dictionary
        db.collection("users").document(documentID).setData(dataToSave){ error in
            if let error = error{
                print("😬 error: \(error.localizedDescription) could not save data for documentID")
            }
        }
    }
    
}
