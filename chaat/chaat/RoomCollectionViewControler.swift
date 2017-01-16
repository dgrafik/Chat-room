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
import GoogleSignIn
import JSQMessagesViewController


class RoomCollectionViewControler: UICollectionViewController, UICollectionViewDelegateFlowLayout{
    
    var ROOMID: String!

    
    @IBAction func didtaped(sender: UIBarButtonItem) {
        do{
            try FIRAuth.auth()?.signOut()
            GIDSignIn.sharedInstance().signOut()
            
        } catch let error{
            print(error)
        }
        
        //Stwórz główną instancję (main) storyboard
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        //Z głównego storyboardu stwórz instantiate View controller
        let loginVC = storyboard.instantiateViewControllerWithIdentifier("LoginVC") as! LoginViewController
        // App Delegate -> get
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        //Ustaw login view controller jako root
        appDelegate.window?.rootViewController = loginVC    }
    
    var rooms = [Room]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //DataService.dataService.fetchDataFromServer{ (room) in
          //  self.rooms.append(room)
          //  let indexPath = NSIndexPath(forItem: self.rooms.count - 1, inSection: 0)
          //  self.collectionView?.insertItemsAtIndexPaths([indexPath])
        
        
            DataService.dataService.ROOM_REF.observeEventType(.ChildAdded, withBlock:
                {(snapshot) -> Void in
                    let room = Room(key: snapshot.key, snapshot: snapshot.value as! Dictionary<String, AnyObject>)
                    self.rooms.append(room)
                    let indexPath = NSIndexPath(forItem: self.rooms.count - 1, inSection: 0)
                    self.collectionView?.insertItemsAtIndexPaths([indexPath])
                    
            })
            
        //}
        
    }

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return rooms.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("roomCell", forIndexPath: indexPath) as! RoomCollectionViewCell
        let room = rooms[indexPath.row]
        cell.configureCell(room)
        //self.collectionView!.reloadData()
        return cell
        
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake(view.frame.size.width / 2 - 5, view.frame.size.width / 2 - 5)
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ChatSegue"{
            let cell = sender as! RoomCollectionViewCell
            let indexPath = collectionView?.indexPathForCell(cell)
            let room = rooms[indexPath!.item]
            let chatViewController = segue.destinationViewController as! ChatViewController
            chatViewController.roomId = room.id
            chatViewController.romName = room.caption
    }
}
    
}
