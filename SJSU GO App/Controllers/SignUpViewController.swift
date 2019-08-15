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
    
    var majorButton = DropDownButton()
    var majorButtonConstraints = [NSLayoutConstraint]()
    
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
        delegateTextFields()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
//        configureMajorButton()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        clearTextFields()
        
//        NSLayoutConstraint.deactivate(majorButtonConstraints)
//        majorButton.dropView.removeFromSuperview()
//        self.majorButton.removeFromSuperview()
//        majorButton.removeFromSuperview()
    }
    
    func configureMajorButton() {
        majorButton = DropDownButton.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        majorButton.setTitle("Major", for: .normal)
        majorButton.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(majorButton)
        let centerXAnchor = majorButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
        let centerYAnchor = majorButton.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
        let widthAnchor = majorButton.widthAnchor.constraint(equalToConstant: 150)
        let heightAnchor = majorButton.heightAnchor.constraint(equalToConstant: 40)
        
        majorButtonConstraints.append(contentsOf: [centerXAnchor, centerYAnchor, widthAnchor, heightAnchor])
        NSLayoutConstraint.activate(majorButtonConstraints)
        
        majorButton.dropView.dropDownOptions = ["Aerospace Engineering", "Computer Engineering", "Electrical Engineering", "Software Engineering"]
    }
    
    func configureAcademicYearButton() {
        
    }
    
    // MARK: Actions
    
    @IBAction func cancel(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func signUp(_ sender: Any) {
        
        guard idTextField.hasText && passwordTextField.hasText && emailTextField.hasText && firstNameTextField.hasText && lastNameTextField.hasText else {
            print("Please fill in every text field except for the major and academic year.")
            return
        }
        
        guard let sjsuId = idTextField.text, let sjsuPassword = passwordTextField.text, let sjsuEmail = emailTextField.text, let firstName = firstNameTextField.text, let lastName = lastNameTextField.text else {
            print("Sign up failed")
            return
        }
        
        Auth.auth().createUser(withEmail: sjsuEmail, password: sjsuPassword) { (user, error) in
            
            if error != nil {
                print("Error creating user: \(error!.localizedDescription)")
                return
            }
            
            guard let uid = user?.user.uid else {
                return
            }
            
            let values = ["sjsu_id": sjsuId, "sjsu_email": sjsuEmail, "sjsu_password": sjsuPassword, "first_name": firstName, "last_name": lastName]
            
            self.registerUserIntoDatabaseWithUID(uid, values: values as [String : AnyObject])
        }
    }
    
    func registerUserIntoDatabaseWithUID(_ uid: String, values: [String: AnyObject]) {
        let ref = Database.database().reference()
        let usersReference = ref.child("users").child(uid)
        
        usersReference.updateChildValues(values) { (error, ref) in
            
            if let error = error {
                print("Error updating child values in database: ", error)
                return
            }
            
            self.navigationController?.popViewController(animated: true)
        }
    }
}

// MARK: - UITextFieldDelegate

extension SignUpViewController: UITextFieldDelegate {
    func delegateTextFields() {
        idTextField.delegate = self
        passwordTextField.delegate = self
        emailTextField.delegate = self
        firstNameTextField.delegate = self
        lastNameTextField.delegate = self
    }
    
    func clearTextFields() {
        idTextField.text = ""
        passwordTextField.text = ""
        emailTextField.text = ""
        firstNameTextField.text = ""
        lastNameTextField.text = ""
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
}

// MARK: - DropDownButton

protocol DropDownProtocol {
    func dropDownPressed(string: String)
}

class DropDownButton: UIButton, DropDownProtocol {
    
    func dropDownPressed(string: String) {
        self.setTitle(string, for: .normal)
        self.dismissDropDown()
    }
    
    var dropView = DropDownView()
    var height = NSLayoutConstraint()
    var dropViewConstraints = [NSLayoutConstraint]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.darkGray
        
        dropView = DropDownView.init(frame: CGRect.init(x: 0, y: 0, width: 0, height: 0))
        dropView.delegate = self
        dropView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    deinit {
        NSLayoutConstraint.deactivate(dropViewConstraints)
        dropView.removeFromSuperview()
        self.dropView.removeFromSuperview()
        self.removeFromSuperview()
    }
    
    override func didMoveToSuperview() {
        self.superview?.addSubview(dropView)
        self.superview?.bringSubviewToFront(dropView)
        
        let topAnchor = dropView.topAnchor.constraint(equalTo: self.bottomAnchor)
        let centerXAnchor = dropView.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        let widthAnchor = dropView.widthAnchor.constraint(equalTo: self.widthAnchor)
        height = dropView.heightAnchor.constraint(equalToConstant: 0)
        
        dropViewConstraints.append(contentsOf: [topAnchor, centerXAnchor, widthAnchor, height])
        NSLayoutConstraint.activate(dropViewConstraints)
    }
    
    var isOpen = false
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if isOpen == false {
            isOpen = true
            
            NSLayoutConstraint.deactivate([self.height])
            
            if self.dropView.tableView.contentSize.height > 150 {
                self.height.constant = 150
            } else {
                self.height.constant = self.dropView.tableView.contentSize.height
            }
            
            NSLayoutConstraint.activate([self.height])
            
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut, animations: {
                self.dropView.layoutIfNeeded()
                self.dropView.center.y += self.dropView.frame.height / 2
            }, completion: nil)
        } else {
            isOpen = false
            
            NSLayoutConstraint.deactivate([self.height])
            self.height.constant = 0
            NSLayoutConstraint.activate([self.height])
            
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut, animations: {
                self.dropView.center.y -= self.dropView.frame.height / 2
                self.dropView.layoutIfNeeded()
            }, completion: nil)
        }
    }
    
    func dismissDropDown() {
        isOpen = false
        
        NSLayoutConstraint.deactivate([self.height])
        self.height.constant = 0
        NSLayoutConstraint.activate([self.height])
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
            self.dropView.center.y -= self.dropView.frame.height / 2
            self.dropView.layoutIfNeeded()
        }, completion: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class DropDownView: UIView, UITableViewDelegate, UITableViewDataSource {
    
    var dropDownOptions = [String]()
    var tableView = UITableView()
    var delegate: DropDownProtocol!
    var dropDownConstraints = [NSLayoutConstraint]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        tableView.backgroundColor = UIColor.white
        self.backgroundColor = UIColor.white
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(tableView)
        
        let leftAnchor = tableView.leftAnchor.constraint(equalTo: self.leftAnchor)
        let rightAnchor = tableView.rightAnchor.constraint(equalTo: self.rightAnchor)
        let topAnchor = tableView.topAnchor.constraint(equalTo: self.topAnchor)
        let bottomAnchor = tableView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        
        dropDownConstraints.append(contentsOf: [leftAnchor, rightAnchor, topAnchor, bottomAnchor])
        NSLayoutConstraint.activate(dropDownConstraints)
    }
    
    deinit {
        NSLayoutConstraint.deactivate(dropDownConstraints)
        tableView.removeFromSuperview()
        self.tableView.removeFromSuperview()
        self.removeFromSuperview()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dropDownOptions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        
        cell.textLabel?.text = dropDownOptions[indexPath.row]
        cell.backgroundColor = UIColor.white
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.delegate.dropDownPressed(string: dropDownOptions[indexPath.row])
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
}
