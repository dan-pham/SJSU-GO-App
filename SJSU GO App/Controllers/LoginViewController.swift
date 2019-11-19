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
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var logInButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    
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
    
    @IBAction func logIn(_ sender: Any) {
        
        guard emailTextField.hasText && passwordTextField.hasText else {
            Alerts.showSignInFailedAlertVC(on: self)
            return
        }
        
        guard let email = emailTextField.text, let password = passwordTextField.text else {
            Alerts.showRestartAlertVC(on: self)
            return
        }
        
        activityIndicator.showActivityIndicator()
        
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            
            if let error = error {
                self.activityIndicator.hideActivityIndicator()
                Alerts.showAuthenticateUserFailedAlertVC(on: self, message: error.localizedDescription)
                return
            }
            
            self.activityIndicator.hideActivityIndicator()
            
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

