//
//  ProfileViewController.swift
//  SJSU GO App
//
//  Created by Dan Pham on 8/23/19.
//  Copyright © 2019 Dan Pham. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class ProfileViewController: UIViewController {
    
    @IBAction func ShowOrderHistory(_ sender: Any)
    {
        
        let popUpVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier:"OrderHistory") as!OrderHistory
        self.addChild(popUpVC)
        popUpVC.view.frame = self.view.frame
        self.view.addSubview(popUpVC.view)
        
        // go to order History view
        
        popUpVC.didMove(toParent: self)

    }
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var qrCodeImageView: UIImageView!
    
    @IBOutlet weak var qrCodeScannerButton: UIButton!
    @IBOutlet weak var pendingEventsButton: UIButton!
    
    let activityIndicator = ActivityIndicator()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        setBackgroundColors()
        setupUserProfile()
        checkDeviceForCamera()
    }
    
    func setBackgroundColors() {
        Colors.setLightBlueColor(view: self.view)
    }
    
    func setupUserProfile() {
        configureUserName()
        configureUserProfileImage()
        configureUserQRCode()
    }
    
    func configureUserName() {
        if let firstName = TabBarViewController.user.firstName, let lastName = TabBarViewController.user.lastName {
            nameLabel.text = "\(firstName) \(lastName)"
        }
    }
    
    func configureUserProfileImage() {
        if let profileImageUrl = TabBarViewController.user.profileImageUrl {
            profileImageView.loadImageUsingCacheWithUrlString(profileImageUrl) { (image) in
                DispatchQueue.main.async { self.profileImageView.image = image }
            }
        } else {
            profileImageView.image = UIImage(named: "profilePlaceholderImage")
        }
        
        profileImageView.contentMode = .scaleAspectFit
        profileImageView.backgroundColor = .lightGray
        
        profileImageView.layer.cornerRadius = 50
        profileImageView.layer.borderColor = UIColor.black.cgColor
        profileImageView.layer.borderWidth = 1
        
        profileImageView.isUserInteractionEnabled = true
        profileImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSelectProfileImageView)))
    }
    
    @objc func handleSelectProfileImageView() {
        let picker = UIImagePickerController()
        
        picker.delegate = self
        picker.allowsEditing = true
        
        present(picker, animated: true, completion: nil)
    }
    
    func handleUpdateUserProfileImage(image: UIImage) {
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        
        activityIndicator.showActivityIndicator(self)
        
        let imageName = UUID().uuidString
        let storageRef = Storage.storage().reference().child("profile_images").child("\(imageName).jpg")
        
        if let uploadData = image.jpegData(compressionQuality: 0.1) {
            
            storageRef.putData(uploadData, metadata: nil) { (_, error) in
                
                if let error = error {
                    self.activityIndicator.hideActivityIndicator(self)
                    Alerts.showUploadImageFailedAlertVC(on: self, message: error.localizedDescription)
                    return
                }
                
                storageRef.downloadURL(completion: { (url, err) in
                    if let err = err {
                        self.activityIndicator.hideActivityIndicator(self)
                        Alerts.showDownloadUrlFailedAlertVC(on: self, message: err.localizedDescription)
                        return
                    }
                    
                    guard let url = url else {
                        self.activityIndicator.hideActivityIndicator(self)
                        return
                    }
                    
                    let values = ["profile_image_url": url.absoluteString]
                    
                    self.handleUpdateUserProfileImageIntoDatabaseWithURL(uid, values: values as [String : AnyObject])
                    
                    DispatchQueue.main.async {
                        self.activityIndicator.hideActivityIndicator(self)
                    }
                })
            }
        }
    }
    
    func handleUpdateUserProfileImageIntoDatabaseWithURL(_ uid: String, values: [String: AnyObject]) {
        
        let ref = Database.database().reference()
        let userReference = ref.child("users").child(uid)
        userReference.updateChildValues(values) { (err, ref) in
            
            if let err = err {
                self.activityIndicator.hideActivityIndicator(self)
                Alerts.showUpdateFailedAlertVC(on: self, message: err.localizedDescription)
                return
            }

        }
    }
    
    // TODO: Test QR code generator on iPhone
    func configureUserQRCode() {
        if let sjsuId = TabBarViewController.user.sjsuId {
            print("sjsuId going into QR code: ", sjsuId)
            
            let data = sjsuId.data(using: .isoLatin1, allowLossyConversion: false)
            
            let filter = CIFilter(name: "CIQRCodeGenerator")
            filter?.setValue(data, forKey: "inputMessage")
            
            let ciImage = filter?.outputImage
            
            let affineTransform = CGAffineTransform(scaleX: 10, y: 10)
            let transformedImage = ciImage?.transformed(by: affineTransform)
            
            let qrCodeImage = UIImage(ciImage: transformedImage!)
            
            qrCodeImageView.image = qrCodeImage
        }
    }
    
    func checkDeviceForCamera() {
        qrCodeScannerButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
    }
    
    @IBAction func openQRCodeScanner(_ sender: Any) {
        Alerts.showFeatureInDevelopmentAlertVC(on: self)
        
        // Uncomment following lines to access QR scanner
//        let qrCodeScannerVC = storyboard?.instantiateViewController(withIdentifier: "QRCodeScannerViewController")
//
//        navigationController?.navigationBar.isHidden = true
//        navigationController?.pushViewController(qrCodeScannerVC!, animated: true)
    }
    
    @IBAction func openPendingEvents(_ sender: Any) {
        let pendingEventsVC = storyboard?.instantiateViewController(withIdentifier: "PendingEventsViewController")
        
        navigationController?.navigationBar.isHidden = true
        navigationController?.pushViewController(pendingEventsVC!, animated: true)
    }
    
}

extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        var selectedImageFromPicker: UIImage?
        let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)
        
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            selectedImageFromPicker = editedImage
        } else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            selectedImageFromPicker = originalImage
        }
        
        if let selectedImage = selectedImageFromPicker {
            profileImageView.image = selectedImage
            handleUpdateUserProfileImage(image: selectedImage)
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
        return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
    }
    
}
