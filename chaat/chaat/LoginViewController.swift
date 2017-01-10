//
//  LoginViewController.swift
//  chaat
//
//  Created by Dominik Grafik on 22.11.2016.
//  Copyright © 2016 Dominik Grafik. All rights reserved.
//

import UIKit
import GoogleSignIn
import FirebaseAuth
import FirebaseDatabase
class LoginViewController: UIViewController, GIDSignInDelegate, GIDSignInUIDelegate  {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //Border colour and width
        
        //logAnon.layer.borderWidth = 1.8
        //logAnon.layer.borderColor = UIColor.whiteColor().CGColor
        //logAnon.layer.cornerRadius = 5
        
        GIDSignIn.sharedInstance().clientID = "581189176802-76f7rjt7vlvs5rvfl20qb7rt6ohv76j9.apps.googleusercontent.com"
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().delegate = self
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        FIRAuth.auth()?.addAuthStateDidChangeListener({ (auth: FIRAuth, user: //autologin
            FIRUser?) in
            
            if user != nil{
                print(user)
                Helper.helper.switchToNavigationViewController()
            }else{
                print("unauto")
            }
            
        })
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    //@IBAction func logAnonDidTaped(sender: AnyObject) {
        //print("ANon")
        //Helper.helper.logAnonymously()
    //}
    @IBAction func logAnonDidTaped(sender: AnyObject) {
        print("ANon")
        Helper.helper.logAnonymously()
    }
    @IBAction func logGoogleDidTaped(sender: AnyObject) {
        print("Google")
        GIDSignIn.sharedInstance().signIn()
    }
    
    //@IBOutlet weak var logAnon: UIButton!
    
    @IBOutlet weak var logAnon: UIButton!
    func signIn(signIn: GIDSignIn!, didSignInForUser user: GIDGoogleUser!, withError error: NSError!){
        
        if error != nil{
            print(error!.localizedDescription)
        }
        print(user.authentication)
        Helper.helper.loginWithGoogle(user.authentication)
    }

    
}