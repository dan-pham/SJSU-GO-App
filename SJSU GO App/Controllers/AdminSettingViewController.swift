//
//  AdminSettingViewController.swift
//  SJSU GO App
//
//  Created by Chanip Chong on 11/23/19.
//  Copyright © 2019 Dan Pham. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class AdminSettingViewController: UIViewController
{
    var ref: DatabaseReference!
    var email = ""
    var currentUID = ""
    
    @IBAction func Switch(_ sender: UISwitch) {

        if (sender.isOn == true) {
            Database.database().reference().child("PrizeSession").setValue("open")
        } else {
            Database.database().reference().child("PrizeSession").setValue("closed")
        }
    }
    
    @IBAction func Confirm(_ sender: Any)
    {
        // get user's info
        let uid = Auth.auth().currentUser!.uid
        let ref = Database.database().reference().child("users").child(uid)
        ref.observeSingleEvent(of: .value) { (snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject] {
                self.email = dictionary["sjsu_email"] as? String ?? "none"
                self.currentUID = dictionary["user_id"] as? String ?? "none"
            }
        }
        
        if let text = New_sjsu_email.text {
            print ("searching for " + text)
            
            //searching same sjsu email
            let query = Database.database().reference().child("users").queryOrdered(byChild: "sjsu_email").queryEqual(toValue: text)
            query.observeSingleEvent(of: .value) { (snapshot) in
                if let dictionary = snapshot.value as? [String: AnyObject] {
                    for (UID, others) in dictionary {
                        if (self.currentEmail.text == self.email) {
                           //give privilege
                            Database.database().reference().child("users").child(UID).child("privilege").setValue("Admin")
                            // cancel privilege
                            Database.database().reference().child("users").child(self.currentUID).child("privilege").setValue("User")
                            print("Admin transfered")
                            Alerts.showAdminTransferSuccessAlertVC(on: self, action: (UIAlertAction(title: "OK", style: .default) {_ in
                                // log out the current user
                                do {
                                    try Auth.auth().signOut()
                                } catch let signOutError {
                                    Alerts.showLogOutErrorAlertVC(on: self, message: signOutError.localizedDescription)
                                }

                                let loginNC = self.storyboard?.instantiateViewController(withIdentifier: "loginNavController")
                                loginNC?.modalPresentationStyle = .fullScreen
                                self.present(loginNC!, animated: true, completion: nil)
                            }))

                        } else {
                            print("Current Email doesn't match!")
                            Alerts.showCurrentAdminEmailNotMatchedAlertVC(on: self)
                        }
                    }
                
                //let uid = data["user_id"] as! String
                //print (uid)
                } else {
                    Alerts.showNewAdminEmailNotFoundAlertVC(on: self)
                }
            }
        } else {
            Alerts.showAdminTransferFailedAlertVC(on: self)
            return
        }
    }
    
    @IBOutlet weak var currentEmail: UITextField!
    @IBOutlet weak var New_sjsu_email: UITextField!
    @IBOutlet weak var prizeSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setBackgroundColors()
        checkFirebaseForSwitchState()
    }
    
    func setBackgroundColors() {
        Colors.setLightBlueColor(view: self.view)
    }
    
    func checkFirebaseForSwitchState() {
        let ref = Database.database().reference().child("PrizeSession")
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            if let switchState = snapshot.value as? String {
                print("switchState: \(switchState)")
                if switchState == "open" {
                    self.prizeSwitch.setOn(true, animated: false)
                } else {
                    self.prizeSwitch.setOn(false, animated: false)
                }
            }
        }, withCancel: nil)
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
}
