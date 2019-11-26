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
    
    let majors = ["Aerospace Engineering", "Aviation", "Biomedical Engineering", "Chemical Engineering", "Civil Engineering", "Computer Engineering", "Electrical Engineering", "Engineering Management", "General Engineering", "Human Factor/Ergonomics", "Industrial and Systems Engineering", "Industrial Technology",  "Materials Engineering", "Mechanical Engineering", "Software Engineering"]
    let academicYears = ["2000", "2001", "2002", "2003", "2004", "2005", "2006", "2007", "2008", "2009", "2010", "2011", "2012", "2013", "2014", "2015", "2016", "2017", "2018", "2019", "2020"]
    var selectedFieldData = [String]()
    
    let activityIndicator = ActivityIndicator()
    
    // MARK: Outlets
    
    @IBOutlet weak var idTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var majorTextField: UITextField!
    @IBOutlet weak var academicYearTextField: UITextField!
    @IBOutlet weak var pickerView: UIPickerView!
    
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var signUpButton: UIBarButtonItem!
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setBackgroundColors()
        delegateTextFields()
        configurePickerView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        clearTextFields()
    }
    
    func setBackgroundColors() {
        Colors.setLightBlueColor(view: self.view)
    }
    
    func configurePickerView() {
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView.isHidden = true
    }
    
    // MARK: Actions
    
    @IBAction func cancel(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func signUp(_ sender: Any) {
        
        guard idTextField.hasText && passwordTextField.hasText && emailTextField.hasText && firstNameTextField.hasText && lastNameTextField.hasText && majorTextField.hasText && academicYearTextField.hasText else {
            Alerts.showSignUpFailedAlertVC(on: self)
            return
        }
        
        guard let sjsuId = idTextField.text, let sjsuPassword = passwordTextField.text, let sjsuEmail = emailTextField.text, let firstName = firstNameTextField.text, let lastName = lastNameTextField.text, let major = majorTextField.text, let academicYear = academicYearTextField.text else {
            Alerts.showRestartAlertVC(on: self)
            return
        }
        
        activityIndicator.showActivityIndicator(self)
        
        Auth.auth().createUser(withEmail: sjsuEmail, password: sjsuPassword) { (user, error) in
            
            if error != nil {
                self.activityIndicator.hideActivityIndicator(self)
                Alerts.showCreateUserFailedAlertVC(on: self, message: error!.localizedDescription)
                return
            }
            
            guard let uid = user?.user.uid else {
                self.activityIndicator.hideActivityIndicator(self)
                return
            }
            
            let points = 0
            let privilege = "User"
            
            let values = ["user_id": uid, "sjsu_id": sjsuId, "sjsu_email": sjsuEmail, "first_name": firstName, "last_name": lastName, "major": major, "academic_year": academicYear, "points": points, "privilege": privilege] as [String: AnyObject]
            
//            self.registerUserIntoFirestoreWithUID(uid, values: values)
            self.registerUserIntoDatabaseWithUID(uid, values: values)
        }
    }
    
//    func registerUserIntoFirestoreWithUID(_ uid: String, values: [String: AnyObject]) {
//        let ref = Firestore.firestore()
//        let usersReference = ref.collection("users").document(uid)
//        usersReference.setData(values, merge: true) { (error) in
//            if let error = error {
//                self.activityIndicator.hideActivityIndicator()
//                Alerts.showCreateUserFailedAlertVC(on: self, message: error.localizedDescription)
//                return
//            }
//
//            self.activityIndicator.hideActivityIndicator()
//            self.navigationController?.popViewController(animated: true)
//        }
//    }
    
    func registerUserIntoDatabaseWithUID(_ uid: String, values: [String: AnyObject]) {
        let ref = Database.database().reference()
        let usersReference = ref.child("users").child(uid)

        usersReference.updateChildValues(values) { (error, ref) in

            if let error = error {
                self.activityIndicator.hideActivityIndicator(self)
                Alerts.showCreateUserFailedAlertVC(on: self, message: error.localizedDescription)
                return
            }

            self.activityIndicator.hideActivityIndicator(self)
            self.navigationController?.popViewController(animated: true)
        }
    }
}

// MARK: - UITextField

extension SignUpViewController: UITextFieldDelegate {
    
    func delegateTextFields() {
        idTextField.delegate = self
        passwordTextField.delegate = self
        emailTextField.delegate = self
        firstNameTextField.delegate = self
        lastNameTextField.delegate = self
        majorTextField.delegate = self
        academicYearTextField.delegate = self
    }
    
    func clearTextFields() {
        idTextField.text = ""
        passwordTextField.text = ""
        emailTextField.text = ""
        firstNameTextField.text = ""
        lastNameTextField.text = ""
        majorTextField.text = ""
        academicYearTextField.text = ""
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if (textField == majorTextField) {
            selectedFieldData = majors
            pickerView.reloadAllComponents()
            pickerView.isHidden = false
            textField.endEditing(true)
        } else if (textField == academicYearTextField) {
            selectedFieldData = academicYears
            pickerView.reloadAllComponents()
            pickerView.isHidden = false
            textField.endEditing(true)
        } else {
            pickerView.isHidden = true
        }
    }
    
}

// MARK: - UIPickerView

extension SignUpViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return selectedFieldData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return selectedFieldData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if selectedFieldData == majors {
            majorTextField.text = majors[row]
        } else if selectedFieldData == academicYears {
            academicYearTextField.text = academicYears[row]
        }
        
        perform(#selector(hidePickerView), with: nil, afterDelay: 1)
    }
    
    @objc func hidePickerView() {
        pickerView.isHidden = true
    }
    
}
