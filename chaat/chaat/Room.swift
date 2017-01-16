//
//  Room.swift
//  chaat
//
//  Created by Dominik Grafik on 03.01.2017.
//  Copyright © 2017 Dominik Grafik. All rights reserved.
//

import Foundation
import UIKit
import FirebaseStorage

class Room{
    var caption: String!
    var thumbnail: String!
    var id: String!
    
    init(key: String, snapshot: Dictionary<String, AnyObject>){
        self.id = key
        self.caption = snapshot["caption"] as! String
        self.thumbnail = snapshot["thunbanilUrlFromStorage"] as! String
    }
}
