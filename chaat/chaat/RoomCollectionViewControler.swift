//
//  RoomCollectionViewControler.swift
//  chaat
//
//  Created by Dominik Grafik on 01.01.2017.
//  Copyright © 2017 Dominik Grafik. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseStorage

class RoomCollectionViewControler: UICollectionViewController{
    var rooms = [Room]()
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 0
    }

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        //let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIndetifier, forIndexPath: indexPath)
        
        //return cell
    }
}