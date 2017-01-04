//
//  CreateRoomViewController.swift
//  
//
//  Created by Dominik Grafik on 02.01.2017.
//
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseStorage


class CreateRoomViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate{
    var roomId: String!
    var seletedPhoto: UIImage?
    override func viewDidLoad() {
        super.viewDidLoad()
        let dismissKeyboard = UITapGestureRecognizer(target: self, action: #selector(CreateRoomViewController.dismissKeyboard(_:)))
        dismissKeyboard.numberOfTapsRequired = 1
        view.addGestureRecognizer(dismissKeyboard)
        
        
    }
    func dismissKeyboard(tap: UITapGestureRecognizer){
        view.endEditing(true)
    }
    
    //przycisk cancel ? 
    //dismissViewControllerAnimated(true, completion: nil)
    
    @IBOutlet weak var choosePhoto: UIButton!
    @IBOutlet weak var chooseImage: UIImageView!
    @IBOutlet weak var captionLbl: UITextField!
    
    @IBAction func cancelDidTaped(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func selectPhotoDidTaped(sender: AnyObject) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        if UIImagePickerController.isSourceTypeAvailable(.Camera){
            imagePicker.sourceType = .Camera
            
        }else{
            imagePicker.sourceType = .PhotoLibrary
        }
        
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        seletedPhoto = info[UIImagePickerControllerEditedImage] as? UIImage
        chooseImage.image = seletedPhoto
        picker.dismissViewControllerAnimated(true, completion: nil)
        choosePhoto.hidden = true
    }
    @IBAction func CreateRoom(sender: AnyObject) {
        var data: NSData = NSData()
        data = UIImageJPEGRepresentation(chooseImage.image!, 0.1)!
        CreateNewRoom(FIRAuth.auth()!.currentUser!, caption: captionLbl.text!, data: data)
    }
    
    var fileUrl: String!
    
    func CreateNewRoom(user: FIRUser, caption: String, data: NSData){
        let filePath = "\(user.uid)/\(Int(NSDate.timeIntervalSinceReferenceDate()))"
        let metaData = FIRStorageMetadata()
        metaData.contentType = "image/jpg"
        FIRStorage.storage().reference().child(filePath).putData(data, metadata:metaData){ (metadata, error) in
            if let error = error{
                print("Error uploading: \(error.description)")
                return
            }
            self.fileUrl = metadata!.downloadURLs![0].absoluteString
            if let user = FIRAuth.auth()?.currentUser{
                let idRoom = FIRDatabase.database().reference().child("rooms").childByAutoId()
                idRoom.setValue(["caption": caption, "thunbanilUrlFromStorage": FIRStorage.storage().reference().child(metadata!.path!).description, "fileUrl": self.fileUrl])
            }
        }
    }
}