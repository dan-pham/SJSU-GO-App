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
    
    // MARK: Outlets
    @IBOutlet weak var emailTextField: UITextField! // Change to email
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var logInButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegateTextFields()
        passwordTextField.isSecureTextEntry = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        clearTextFields()
    }
    
    // MARK: Actions
    
    @IBAction func logIn(_ sender: Any) {
        
        guard let email = emailTextField.text, let password = passwordTextField.text else {
            print("Log in failed")
            return
        }
        
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            
            if let error = error {
                print("Error signing in: ", error)
                return
            }
            
            let tabBarNavController = self.storyboard?.instantiateViewController(withIdentifier: "tabBarNavController")
            self.present(tabBarNavController!, animated: true)
        }
        
    }
    
    @IBAction func signUp(_ sender: Any) {
        let signUpVC = storyboard?.instantiateViewController(withIdentifier: "SignUpViewController") as! SignUpViewController
        
        navigationController?.navigationBar.isHidden = true
        navigationController?.pushViewController(signUpVC, animated: true)
    }
    
}

// MARK: - UITextFieldDelegate

extension LoginViewController: UITextFieldDelegate {
    func delegateTextFields() {
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    func clearTextFields() {
        emailTextField.text = ""
        passwordTextField.text = ""
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
}

