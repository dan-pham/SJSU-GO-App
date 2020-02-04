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

class LoginViewController: UIViewController
{
    // MARK: Outlets
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var logInButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    
    var userPrivilege = String()
    let activityIndicator = ActivityIndicator()
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        setBackgroundColors()
        delegateTextFields()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        clearTextFields()
    }
    
    func setBackgroundColors() {
        Colors.setLightBlueColor(view: self.view)
    }
    
    // MARK: Actions
    
    @IBAction func logIn(_ sender: Any)
    {
        
        guard emailTextField.hasText && passwordTextField.hasText else {
            Alerts.showSignInFailedAlertVC(on: self)
            return
        }
        
        guard let email = emailTextField.text, let password = passwordTextField.text else {
            Alerts.showRestartAlertVC(on: self)
            return
        }
        
        activityIndicator.showActivityIndicator(self)
        
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            
            if let error = error
            {
                self.activityIndicator.hideActivityIndicator(self)
                Alerts.showAuthenticateUserFailedAlertVC(on: self, message: error.localizedDescription)
                return
            }
            
            /// after authentication, see if user is an admin
             let uid = Auth.auth().currentUser!.uid
             let ref = Database.database().reference().child("users").child(uid)

             ref.observeSingleEvent(of: .value) { (snapshot) in

                if let dictionary = snapshot.value as? [String: AnyObject] {
                    self.userPrivilege = dictionary["privilege"] as? String ?? "User"
                    print ("self.userPrivilege is " + self.userPrivilege);
                }

                if self.userPrivilege == "Admin" {
                    print ("Admin login");
                    self.activityIndicator.hideActivityIndicator(self)
                    let pendingEventsVC = self.storyboard?.instantiateViewController(withIdentifier: "PendingEventsViewController")

                    self.navigationController?.navigationBar.isHidden = true
                    self.navigationController?.pushViewController(pendingEventsVC!, animated: true)
                } else {
                    self.activityIndicator.hideActivityIndicator(self)
                    let tabBarNavController = self.storyboard?.instantiateViewController(withIdentifier: "tabBarNavController")
                    tabBarNavController?.modalPresentationStyle = .fullScreen
                    self.present(tabBarNavController!, animated: true)
                }
            }

        }
            
    }
    
    @IBAction func signUp(_ sender: Any) {
        let signUpVC = storyboard?.instantiateViewController(withIdentifier: "SignUpViewController") as! SignUpViewController
        signUpVC.modalPresentationStyle = .fullScreen
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

