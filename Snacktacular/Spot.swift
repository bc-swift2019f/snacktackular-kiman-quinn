//
//  Spot.swift
//  Snacktacular
//
//  Created by Kim-An Quinn on 10/30/19.
//  Copyright © 2019 John Gallaugher. All rights reserved.
//

import Foundation
import CoreLocation
import Firebase

class Spot{
    var name: String
    var address: String
    var coordinate: CLLocationCoordinate2D
    var averageRating: Double
    var numberOfReviews: Int
    var postingUserID: String
    var documentID: String
    
    var longitude: CLLocationDegrees{
        return coordinate.longitude
    }
    
    var latitude: CLLocationDegrees{
        return coordinate.latitude
    }
    
    var dictionary: [String: Any]{
        return ["name":name, "address": address, "longitude": longitude, "latitude": latitude, "averageRating": averageRating, "numberOfReviews": numberOfReviews, "postingUserID": postingUserID]
    }
    
    init(name: String, address: String, coordinate: CLLocationCoordinate2D, averageRating: Double, numberOfReviews: Int, postingUserID: String, documentID: String){
        self.name = name
        self.address = address
        self.coordinate = coordinate
        self.averageRating = averageRating
        self.numberOfReviews = numberOfReviews
        self.postingUserID = postingUserID
        self.documentID = documentID
    }
    
    convenience init(){
        self.init(name: "", address: "", coordinate: CLLocationCoordinate2D(), averageRating: 0.0, numberOfReviews: 0, postingUserID: "", documentID: "")
    }
    
    func saveData(completion: @escaping(Bool) -> ()){
        let db = Firestore.firestore()
        //Grab userID
        guard let postingUserID = (Auth.auth().currentUser?.uid) else{
            print("**** Error: Could not save data because we don't have a valid postingUserID")
            return completion(false)
        }
        self.postingUserID = postingUserID
        //create dictionary representing data to save
        let dataToSave = self.dictionary
        //if we have save a record, we have a documentID
        if self.documentID != "" {
            let ref = db.collection("spots").document(self.documentID)
            ref.setData(dataToSave){(error) in
                if let error = error{
                    print("Error: updating document \(self.documentID) \(error.localizedDescription)")
                    completion(false)
                }else{
                    print("^^^ Document updated with ref ID \(ref.documentID)")
                    completion(true)
                }
            }
        }else{
            var ref: DocumentReference? = nil
            ref = db.collection("spots").addDocument(data: dataToSave){ error in
                if let error = error{
                    print("Error: creating new document \(self.documentID) \(error.localizedDescription)")
                    completion(false)
                }else{
                    print("^^^ New document created with ref ID \(ref!.documentID)")
                    completion(true)
                }
            }
        }
    }
    
}
