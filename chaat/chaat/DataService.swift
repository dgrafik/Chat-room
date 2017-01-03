//
//  DataService.swift
//  chaat
//
//  Created by Dominik Grafik on 03.01.2017.
//  Copyright © 2017 Dominik Grafik. All rights reserved.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseStorage
let roofRef = FIRDatabase.database().reference()
class DataService {
    
    static let dataService = DataService() //inicjalizacja
    
    private var _ROOM_REF = roofRef.child("rooms")
    
    var ROOM_REF: FIRDatabaseReference{
        return _ROOM_REF
    }
    func fetchDataFromServer(callback: (Room) -> ()){
        DataService.dataService.ROOM_REF.observeEventType(.ChildAdded, withBlock: {(snapshot) in
                let room = Room(key:snapshot.key, snapshot: snapshot.value as! Dictionary<String, AnyObject>)
            callback(room)
        })
    }
}