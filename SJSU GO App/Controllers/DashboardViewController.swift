//
//  DashboardViewController.swift
//  SJSU GO App
//
//  Created by Dan Pham on 8/18/19.
//  Copyright © 2019 Dan Pham. All rights reserved.
//

import UIKit
import Firebase
import SafariServices

class DashboardViewController: UIViewController {
    
    @IBOutlet weak var pointsLabel: UILabel!
    @IBOutlet weak var eventsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        retrievePointsFromFirebase()
    }
    
    func retrievePointsFromFirebase() {
        let numberOfPoints = 1
        if numberOfPoints == 1 {
            pointsLabel.text = "\(numberOfPoints) point"
        } else {
            pointsLabel.text = "\(numberOfPoints) points"
        }
    }
    
    @IBAction func openFAQInSafari(_ sender: Any) {
        let url = "https://engineering.sjsu.edu/go-faq"
        openLinkInSafari(url: url)
    }
    
    // Feedback can probably be removed since FAQ includes email for feedback
    @IBAction func openFeedbackInSafari(_ sender: Any) {
        let url = "https://engineering.sjsu.edu/contact"
        openLinkInSafari(url: url)
    }
    
    func openLinkInSafari(url: String) {
        guard let url = URL(string: url) else {
            // Show alert
            print("Could not convert string to URL")
            return
        }
        
        let safariVC = SFSafariViewController(url: url)
        present(safariVC, animated: true)
    }
    
}
