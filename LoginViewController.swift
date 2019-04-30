//
//  LoginViewController.swift
//  SJSU GO App
//
//  Created by Dan Pham on 4/10/19.
//  Copyright © 2019 Dan Pham. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class LoginViewController: UIViewController {
    
    // MARK: Properties
    
    
    // MARK: Outlets
    @IBOutlet weak var idTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var logInButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    // MARK: Actions
    
    @IBAction func logIn(_ sender: Any)
    {
        Auth.auth().signIn(withEmail: idTextField.text!, password: passwordTextField.text!)
        { (user, error) in
            
            if error != nil
            {
                print(error!)
            }
                
            else
            {
                print("login successful")
                self.performSegue(withIdentifier: "goToHome", sender: self)
            }
        }
  
    }
    
    @IBAction func signUp(_ sender: Any) {
        let signUpVC = storyboard?.instantiateViewController(withIdentifier: "SignUpViewController") as! SignUpViewController
        navigationController?.pushViewController(signUpVC, animated: true)
    }
    
}
