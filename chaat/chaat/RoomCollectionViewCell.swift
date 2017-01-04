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
    
    
    @IBOutlet weak var thmbnPhoto: UIImageView!
    @IBOutlet weak var captionLbl: UILabel!
    
    func configureCell(room: Room)
    {
        self.captionLbl.text = room.caption
        if let imageUrl = room.thumbnail{
            if imageUrl.hasPrefix("gs://"){
                FIRStorage.storage().referenceForURL(imageUrl).dataWithMaxSize(INT64_MAX, completion: {
                    (data, error) in
                    if let error = error {
                        print("Error downloading: \(error)")
                        return
                    }
                    self.thmbnPhoto.image = UIImage(data: data!)
                })
            }else if let url = NSURL(string: imageUrl), data = NSData(contentsOfURL: url){
                self.thmbnPhoto.image = UIImage.init(data: data)
            }
        }
        
    }
    

}
