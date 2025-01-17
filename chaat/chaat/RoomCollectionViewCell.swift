//
//  RoomCollectionViewCell.swift
//  chaat
//
//  Created by Dominik Grafik on 02.01.2017.
//  Copyright © 2017 Dominik Grafik. All rights reserved.
//

import UIKit
import FirebaseStorage

class RoomCollectionViewCell: UICollectionViewCell {
    let photoCache = NSCache()
    
    @IBOutlet weak var thmbnPhoto: UIImageView!
    @IBOutlet weak var captionLbl: UILabel!
    
    //var nameRoom:String = Room.caption
    
    func configureCell(room: Room)
    {
        self.captionLbl.text = room.caption
        if let imageUrl = room.thumbnail{
            if imageUrl.hasPrefix("gs://"){
                FIRStorage.storage().referenceForURL(imageUrl).dataWithMaxSize(INT64_MAX, completion: {
                    (data, error) in
                    if let error = error {
                        print("Error downloading: \(error)")
                        Helper.helper.switchToNavigationViewController()
                        return
                    }
                    //dispatch_async(dispatch_get_main_queue(), {
                        self.thmbnPhoto.image = UIImage(data: data!)
                                            //}
                })
            }else if let url = NSURL(string: imageUrl), data = NSData(contentsOfURL: url){
                self.thmbnPhoto.image = UIImage.init(data: data)
                self.photoCache.setObject(self.thmbnPhoto.image!, forKey: data)

            }
        }
        
    }
    

}
