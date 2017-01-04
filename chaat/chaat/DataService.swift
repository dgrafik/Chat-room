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
    
    //var roomId: String!
    
    static let dataService = DataService() //inicjalizacja
    
    //FIRDatabase.database().reference().child("message")
    
    private var _ROOM_REF = roofRef.child("rooms")
    private var _MESSAGE_REF = roofRef.child("messages")
    
    //private var _MESS_REF = roofRef.child(roomId).child("message")
    
    var ROOM_REF: FIRDatabaseReference{
        return _ROOM_REF
    }
    
    var MESSAGE_REF: FIRDatabaseReference{
        return _MESSAGE_REF
    }
    
    //var MESS_REF:FIRDatabaseReference{
        //return _MESS_REF
    //}
    
    func fetchDataFromServer(callback: (Room) -> ()){
        DataService.dataService.ROOM_REF.observeEventType(.ChildAdded, withBlock: {(snapshot) in
                let room = Room(key:snapshot.key, snapshot: snapshot.value as! Dictionary<String, AnyObject>)
            callback(room)
        })
    }
    
    func CreateNewMessage(userId: String, roomId: String, textMessage: String, senderDisplayName: String, mediaType: String){
        let idMessage = roofRef.child("messages").childByAutoId()
        DataService.dataService.MESSAGE_REF.child(idMessage.key).setValue(["text": textMessage, "senderId": userId, "senderName": senderDisplayName, "MediaType": mediaType])
        DataService.dataService.ROOM_REF.child(roomId).child("messages").child(idMessage.key).setValue(["text": textMessage, "senderId": userId, "senderName": senderDisplayName, "MediaType": mediaType])
        
    }
    
    func CreateNewMessageMultimedia(fileUrl: String, roomId: String, senderId: String, senderName: String, mediaType: String){
        let idMessage = roofRef.child("messages").childByAutoId()
        DataService.dataService.MESSAGE_REF.child(idMessage.key).setValue(["fileUrl": fileUrl, "senderId": senderId, "senderName": senderName, "MediaType": mediaType])
        DataService.dataService.ROOM_REF.child(roomId).child("messages").child(idMessage.key).setValue(["fileUrl": fileUrl, "senderId": senderId, "senderName": senderName, "MediaType": mediaType])
    }
    

    
}