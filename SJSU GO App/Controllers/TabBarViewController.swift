//
//  TabBarViewController.swift
//  SJSU GO App
//
//  Created by Dan Pham on 8/18/19.
//  Copyright © 2019 Dan Pham. All rights reserved.
//

import UIKit
import Firebase

class TabBarViewController: UITabBarController, UITabBarControllerDelegate {
    
    static var user = User()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        checkIfUserIsLoggedIn()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationController?.navigationBar.isHidden = false
    }
    
    func checkIfUserIsLoggedIn() {
        if Auth.auth().currentUser?.uid == nil {
            perform(#selector(handleLogOut), with: nil, afterDelay: 0)
        }
    }
    
    func reloadViewControllers() {
        let viewControllers = self.viewControllers
        
        for viewController in viewControllers! {
            viewController.loadView()
            viewController.viewDidLoad()
        }
    }
    
    func setupNavTabBars() {
        self.navigationController?.navigationBar.isTranslucent = false
        self.tabBar.isTranslucent = false
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        viewController.loadViewIfNeeded()
        viewController.viewDidLoad()
    }
    
    @IBAction func logOut(_ sender: Any) {
        // TODO: Place an alert to confirm logout
        Alerts.showSignOutAlertVC(on: self, action: (UIAlertAction(title: "Log Out", style: .default) {_ in
            self.handleLogOut()
        }))
    }
    
    @objc func handleLogOut() {
        do {
            try Auth.auth().signOut()
        } catch let signOutError {
            Alerts.showLogOutErrorAlertVC(on: self, message: signOutError.localizedDescription)
        }
        
        let loginNC = storyboard?.instantiateViewController(withIdentifier: "loginNavController")
        loginNC?.modalPresentationStyle = .fullScreen
        present(loginNC!, animated: true, completion: nil)
    }
    
    @IBAction func addEvent(_ sender: Any) {
        let eventSubmissionVC = storyboard?.instantiateViewController(withIdentifier: "EventSubmissionViewController")
       
        navigationController?.navigationBar.isHidden = true
        navigationController?.pushViewController(eventSubmissionVC!, animated: true)
    }
    
}
