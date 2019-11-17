//
//  Alerts.swift
//  SJSU GO App
//
//  Created by Dan Pham on 9/11/19.
//  Copyright © 2019 Dan Pham. All rights reserved.
//

import UIKit

struct Alerts {
    
    private static func showBasicAlertVC(on vc: UIViewController, with title: String, message: String) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        DispatchQueue.main.async {
            vc.present(alertVC, animated: true)
        }
    }
    
    static func showRestartAlertVC(on vc: UIViewController) {
        showBasicAlertVC(on: vc, with: "Unknown Error", message: "Please try again or restart the app")
    }
    
    static func showSignInFailedAlertVC(on vc: UIViewController) {
        showBasicAlertVC(on: vc, with: "Sign In Failed", message: "Please enter your registered email and password")
    }
    
    static func showAuthenticateUserFailedAlertVC(on vc: UIViewController, message: String) {
        showBasicAlertVC(on: vc, with: "Sign In Failed", message: message)
    }
    
    static func showSignUpFailedAlertVC(on vc: UIViewController) {
        showBasicAlertVC(on: vc, with: "Sign Up Failed", message: "Please fill out every field")
    }
    
    static func showCreateUserFailedAlertVC(on vc: UIViewController, message: String) {
        showBasicAlertVC(on: vc, with: "Sign Up Failed", message: message)
    }
    
    static func showLogOutErrorAlertVC(on vc: UIViewController, message: String) {
        showBasicAlertVC(on: vc, with: "Log Out Failed", message: message)
    }
    
    static func showStringToUrlConversionErrorAlertVC(on vc: UIViewController) {
        showBasicAlertVC(on: vc, with: "Link Failed", message: "Could not open URL in Safari")
    }
    
    static func showEventSubmissionFailedAlertVC(on vc: UIViewController) {
        showBasicAlertVC(on: vc, with: "Event Submission Failed", message: "Please fill out every field and attach a photo")
    }
    
    static func showUploadImageFailedAlertVC(on vc: UIViewController, message: String) {
        showBasicAlertVC(on: vc, with: "Upload Image Failed", message: message)
    }
    
    static func showDownloadUrlFailedAlertVC(on vc: UIViewController, message: String) {
        showBasicAlertVC(on: vc, with: "URL Download Failed", message: message)
    }
    
    static func showUpdateFailedAlertVC(on vc: UIViewController, message: String) {
        showBasicAlertVC(on: vc, with: "Update Failed", message: message)
    }
    
    static func showFeatureInDevelopmentAlertVC(on vc: UIViewController) {
        showBasicAlertVC(on: vc, with: "Feature Unavailable", message: "This feature is currently in development")
    }
    
    static func showRemoveEventFailedAlertVC(on vc: UIViewController, message: String) {
        showBasicAlertVC(on: vc, with: "Remove Event Failed", message: message)
    }
    
    static func showNoCaptureDeviceFoundAlertVC(on vc: UIViewController) {
        showBasicAlertVC(on: vc, with: "Error", message: "No capture device found")
    }
    
    static func showAddingSessionInputFailedAlertVC(on vc: UIViewController) {
        showBasicAlertVC(on: vc, with: "Error", message: "Adding session input failed")
    }
    
    
    
    private static func showConfirmationAlertVC(on vc: UIViewController, with title: String, message: String, action: UIAlertAction) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertVC.addAction(action)
        alertVC.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        DispatchQueue.main.async {
            vc.present(alertVC, animated: true)
        }
    }
    
    static func showSignOutAlertVC(on vc: UIViewController, action: UIAlertAction) {
        showConfirmationAlertVC(on: vc, with: "Sign Out", message: "Are you sure you want to sign out?", action: action)
    }
    
    static func showApproveAlertVC(on vc: UIViewController, action: UIAlertAction) {
        showConfirmationAlertVC(on: vc, with: "Approve Submission", message: "Are you sure you want to approve the submission?", action: action)
    }
    
    static func showRejectAlertVC(on vc: UIViewController, action: UIAlertAction) {
        showConfirmationAlertVC(on: vc, with: "Reject Submission", message: "Are you sure you want to reject the submission?", action: action)
    }
    
}
