//
//  SignUpViewController.swift
//  SJSU GO App
//
//  Created by Dan Pham on 3/12/19.
//  Copyright © 2019 Dan Pham. All rights reserved.
//

import UIKit
import Firebase

class SignUpViewController: UIViewController {

    // MARK: Properties
    
    var ref: DatabaseReference!
    
    // MARK: Outlets
    
    @IBOutlet weak var idTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var signUpButton: UIButton!
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        configureDatabase()
    }
    
    func configureDatabase() {
        ref = Database.database().reference()
    }
    
    // MARK: Actions
    
    @IBAction func cancel(_ sender: Any) {
        clearTextFields()
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func signUp(_ sender: Any) {
        if !idTextField.text!.isEmpty  && !passwordTextField.text!.isEmpty && !emailTextField.text!.isEmpty && !firstNameTextField.text!.isEmpty && !lastNameTextField.text!.isEmpty {
            createNewUser()
            clearTextFields()
            navigationController?.popViewController(animated: true)
        } else {
            debugPrint("Please fill in every text field except for the major and academic year.")
        }
    }
    
    func createNewUser() {
        let sjsuId = idTextField.text! as String
        let sjsuPassword = passwordTextField.text! as String
        let sjsuEmail = emailTextField.text! as String
        let firstName = firstNameTextField.text! as String
        let lastName = lastNameTextField.text! as String
        
        Auth.auth().createUser(withEmail: sjsuEmail, password: sjsuPassword) { (user, error) in
            if error != nil
            {
                print(error!)
            }
                // successfuly registered
            else
            {
                let userID = Auth.auth().currentUser!.uid
                print("registration successful")
                
                self.ref.child("users").child(userID).setValue(["sjsu_id": sjsuId,"sjsu_email": sjsuEmail,"sjsu_password": sjsuPassword,"first_name": firstName,"last_name": lastName])
                // go to goToLogin view //
                // self.performSegue(withIdentifier: "goToLogin", sender: self)
            }
            //here
        }
        
        //set value inside userID.
        /*
         ref.child("users/\(userID)/sjsu_id").setValue(sjsuId)
         ref.child("users/\(userID)/sjsu_email").setValue(sjsuEmail)
         ref.child("users/\(userID)/sjsu_password").setValue(sjsuPassword)
         
         ref.child("users/\(userID)/first_name").setValue(firstName)
         ref.child("users/\(userID)/last_name").setValue(lastName)
         */
        
        
        
    }
    
    func clearTextFields() {
        idTextField.text = ""
        passwordTextField.text = ""
        emailTextField.text = ""
        firstNameTextField.text = ""
        lastNameTextField.text = ""
    }
    
}

extension SignUpViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
