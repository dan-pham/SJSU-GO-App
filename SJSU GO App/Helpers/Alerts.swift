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
    
    static func showSignInFailedAlertVC(on vc: UIViewController) {
        showBasicAlertVC(on: vc, with: "Sign In Failed", message: "Please enter your registered email and password")
    }
    
    static func showAuthenticateUserFailedAlertVC(on vc: UIViewController, message: String) {
        showBasicAlertVC(on: vc, with: "Sign In Failed", message: message)
    }
    
    static func showSignUpFailedAlertVC(on vc: UIViewController) {
        showBasicAlertVC(on: vc, with: "Sign Up Failed", message: "Please make sure you fill out every field")
    }
    
    static func showCreateUserFailedAlertVC(on vc: UIViewController, message: String) {
        showBasicAlertVC(on: vc, with: "Sign Up Failed", message: message)
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
