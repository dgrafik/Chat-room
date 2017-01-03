//
//  RoomCollectionViewControler.swift
//  chaat
//
//  Created by Dominik Grafik on 01.01.2017.
//  Copyright © 2017 Dominik Grafik. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseStorage
import Foundation

class RoomCollectionViewControler: UICollectionViewController, UICollectionViewDelegateFlowLayout{
    
    
    var rooms = [Room]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DataService.dataService.fetchDataFromServer{ (room) in
            self.rooms.append(room)
            let indexPath = NSIndexPath(forItem: self.rooms.count - 1, inSection: 0)
            self.collectionView?.insertItemsAtIndexPaths([indexPath])
        }
        
    }
    
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 0
    }

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return rooms.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("roomCell", forIndexPath: indexPath) as! RoomCollectionViewCell
        let room = rooms[indexPath.row]
        cell.configureCell(room)
        return cell
        
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake(view.frame.size.width / 2 - 5, view.frame.size.width / 2 - 5)
    }

  
    
}