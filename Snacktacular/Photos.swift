//
//  Photos.swift
//  Snacktacular
//
//  Created by Kim-An Quinn on 11/11/19.
//  Copyright © 2019 John Gallaugher. All rights reserved.
//

import Foundation
import Firebase

class Photos{
    var photoArray: [Photo] = []
    var db: Firestore!
    
    init(){
        db = Firestore.firestore()
    }
}
