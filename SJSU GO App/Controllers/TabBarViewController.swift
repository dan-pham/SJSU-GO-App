//
//  TabBarViewController.swift
//  SJSU GO App
//
//  Created by Dan Pham on 8/18/19.
//  Copyright © 2019 Dan Pham. All rights reserved.
//

import UIKit
import Firebase

class TabBarViewController: UITabBarController, UITabBarControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        checkIfUserIsLoggedIn()
    }
    
    func checkIfUserIsLoggedIn() {
        if Auth.auth().currentUser?.uid == nil {
            perform(#selector(handleLogOut), with: nil, afterDelay: 0)
        } else {
            print("User successfully logged in")
        }
    }
    
    @IBAction func logOut(_ sender: Any) {
        // TODO: Place an alert to confirm logout
        handleLogOut()
    }
    
    @objc func handleLogOut() {
        do {
            try Auth.auth().signOut()
        } catch let signOutError {
            print(signOutError)
        }
        
        let loginNC = storyboard?.instantiateViewController(withIdentifier: "loginNavController")
        present(loginNC!, animated: true, completion: nil)
    }
    
    @IBAction func addEvent(_ sender: Any) {
        
        
        
    }
    
}
