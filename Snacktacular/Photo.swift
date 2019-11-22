//
//  Photo.swift
//  Snacktacular
//
//  Created by Kim-An Quinn on 11/11/19.
//  Copyright © 2019 John Gallaugher. All rights reserved.
//

import Foundation
import Firebase

class Photo{
    var image: UIImage
    var description: String
    var postedBy: String
    var date: Date
    var documentUUID: String
    var dictionary: [String: Any]{
        return ["description": description, "postedBy": postedBy, "date": date]
    }
    
    init(image: UIImage, description: String, postedBy: String, date: Date, documentUUID: String){
        self.image = image
        self.description = description
        self.postedBy = postedBy
        self.date = date
        self.documentUUID = documentUUID
    }
    
    convenience init(){
        let postedBy = Auth.auth().currentUser?.email ?? "unknown user"
        self.init(image: UIImage(), description: "", postedBy: postedBy, date: Date(), documentUUID: "")
    }
    
    func saveData(spot: Spot, completion: @escaping(Bool) -> ()){
        let db = Firestore.firestore()
        let storage = Storage.storage()
        guard let photoData = self.image.jpegData(compressionQuality: 0.5) else{
            print("***Error: could not convert data")
            return completion(false)
        }
        documentUUID = UUID().uuidString //create unique ID for image name
        // create a ref to upload storage to spot.docID
        let storageRef = storage.reference().child(spot.documentID).child(self.documentUUID)
        let uploadTask = storageRef.putData(photoData)
        
        uploadTask.observe(.success) { (snapshot) in
            //create dictionary representing data to save
            let dataToSave = self.dictionary
            //this will either create a new doc at docUUID or update existing doc with that name
            let ref = db.collection("spots").document(spot.documentID).collection("photos").document(self.documentUUID)
            ref.setData(dataToSave){(error) in
                if let error = error{
                    print("Error: updating document \(self.documentUUID) in spot \(spot.documentID) \(error.localizedDescription)")
                    completion(false)
                }else{
                    print("^^^ Document updated with ref ID \(ref.documentID)")
                    completion(true)
                }
            }
        }
        
        uploadTask.observe(.failure) { (snapshot) in
            if let error = snapshot.error{
                print("*** Error")
            }
            return completion(false)
        }
    }
}
