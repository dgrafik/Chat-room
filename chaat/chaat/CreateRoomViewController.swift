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

    @IBOutlet var keyboardHeightLayoutConstraint: NSLayoutConstraint?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("textFieldDidBeginEditing:"), name:UIKeyboardWillShowNotification, object: nil);
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("textFieldDidEndEditing:"), name:UIKeyboardWillHideNotification, object: nil);
        
        //self.hideKeyboardWhenTappedArround()
        let dismissKeyboard = UITapGestureRecognizer(target: self, action: #selector(CreateRoomViewController.dismissKeyboard(_:)))
        dismissKeyboard.numberOfTapsRequired = 1
        view.addGestureRecognizer(dismissKeyboard)
        
        
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self);
    }

    func dismissKeyboard(tap: UITapGestureRecognizer){
        view.endEditing(true)
    }
    
    

    
    func textFieldDidBeginEditing(textField: UITextField) {
        animateViewMoving(true, moveValue: 100)
    }
    func textFieldDidEndEditing(textField: UITextField) {
        animateViewMoving(false, moveValue: 100)
    }
    
    func animateViewMoving (up:Bool, moveValue :CGFloat){
        var movementDuration:NSTimeInterval = 0.3
        var movement:CGFloat = ( up ? -moveValue : moveValue)
        UIView.beginAnimations( "animateView", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(movementDuration )
        self.view.frame = CGRectOffset(self.view.frame, 0,  movement)
        UIView.commitAnimations()
    }
    
    
    
    
    
    
    
    
    
    //przycisk cancel ?
    //dismissViewControllerAnimated(true, completion: nil)
    
//    func textFieldShouldReturn(textField: UITextField) -> Bool {
//        self.view.endEditing(true)
//        return false
//    }
    
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
        //if UIImagePickerController.isSourceTypeAvailable(.Camera){
           // imagePicker.sourceType = .Camera
            
       //}else{
            imagePicker.sourceType = .SavedPhotosAlbum
        //}
        
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }
    
//    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
//        if let seletedPhoto = info[UIImagePickerControllerEditedImage] as? UIImage{
//            //chooseImage.contentMode = .ScaleAspectFill
//            chooseImage.image = seletedPhoto
//
//        }
//        picker.dismissViewControllerAnimated(true, completion: nil)
//        choosePhoto.hidden = true
//    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            chooseImage.image = image
        } else{
            print("Something went wrong")
        }
        
        picker.dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func CreateRoom(sender: AnyObject) {
        var data: NSData = NSData()
        data = UIImageJPEGRepresentation(chooseImage.image!, 0.4)!
        CreateNewRoom(FIRAuth.auth()!.currentUser!, caption: captionLbl.text!, data: data)
        
        Helper.helper.switchToNavigationViewController()
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
