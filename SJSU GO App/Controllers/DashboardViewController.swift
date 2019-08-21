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
    
    let user = User()
    var events = [UserEvent]()
    var eventsDictionary = [String: UserEvent]()
    let cellId = "cellId"
    
    @IBOutlet weak var pointsLabel: UILabel!
    @IBOutlet weak var eventsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        observeUserEvents()
    }
    
    func setupTableView() {
        eventsTableView.delegate = self
        eventsTableView.dataSource = self
        eventsTableView.register(UserEventCell.self, forCellReuseIdentifier: cellId)
        
        events.removeAll()
        eventsDictionary.removeAll()
        eventsTableView.reloadData()
    }
    
    func observeUserEvents() {
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        
        retrievePointsFromFirebase(uid: uid)
        
        let ref = Database.database().reference().child("user_events").child(uid)
        ref.observe(.childAdded, with: { (snapshot) in
            
            let eventId = snapshot.key
            self.fetchEventWithEventId(eventId: eventId)
            
        }, withCancel: nil)
    }
    
    func fetchEventWithEventId(eventId: String) {
        let eventReference = Database.database().reference().child("events").child(eventId)
        eventReference.observeSingleEvent(of: .value, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject] {
                let event = self.createEventFromDictionary(dictionary)
                
                self.eventsDictionary[eventId] = event
                self.handleReloadTable()
            }
        }, withCancel: nil)
    }
    
    func createEventFromDictionary(_ dictionary: [String: AnyObject]) -> UserEvent {
        let event = UserEvent()
        let tempUser = User()
        var imageUrl = String()
        
        tempUser.firstName = dictionary["user_first_name"] as? String
        tempUser.lastName = dictionary["user_last_name"] as? String
        tempUser.major = dictionary["user_major"] as? String
        tempUser.academicYear = dictionary["user_academic_year"] as? String
        tempUser.email = dictionary["user_email"] as? String
        tempUser.sjsuId = dictionary["user_sjsu_id"] as? String
        event.user = tempUser
        
        event.id = dictionary["id"] as? String
        event.eventType = dictionary["event_type"] as? String
        event.eventDescription = dictionary["event_description"] as? String
        event.isApprovedByAdmin = dictionary["is_approved_by_admin"] as? Bool
        event.points = dictionary["points"] as? Int
        
        imageUrl = dictionary["image_url"] as? String ?? ""
        
        let imageView = UIImageView()
        imageView.loadImageUsingCacheWithUrlString(imageUrl)
        event.image = imageView.image
        
        return event
    }
    
    func handleReloadTable() {
        self.events = Array(self.eventsDictionary.values)
        self.events.sort { (event1, event2) -> Bool in
            return event1.eventType! < event2.eventType!
        }
        
        DispatchQueue.main.async {
            self.eventsTableView.reloadData()
        }
    }
    
    func retrievePointsFromFirebase(uid: String) {
        let userReference = Database.database().reference().child("users").child(uid)
        userReference.observeSingleEvent(of: .value, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject] {
                self.user.points = dictionary["points"] as? Int
                self.updateUserPoints(points: self.user.points ?? 0)
            }
        }, withCancel: nil)
    }
    
    func updateUserPoints(points: Int) {
        if points == 1 {
            pointsLabel.text = "\(points) point"
        } else {
            pointsLabel.text = "\(points) points"
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

extension DashboardViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! UserEventCell
        
        let event = events[indexPath.row]
        cell.event = event
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Open a detail view and pass in information for the event
        // Maybe reference TabBarViewController.presentDetailVC() in animetracker
        print("Selected event at indexPath: ", indexPath)
    }

}
