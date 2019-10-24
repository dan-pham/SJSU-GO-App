//
//  PendingEventsViewController.swift
//  SJSU GO App
//
//  Created by Dan Pham on 8/23/19.
//  Copyright © 2019 Dan Pham. All rights reserved.
//

import UIKit
import Firebase

class PendingEventsViewController: UIViewController {
    
    @IBOutlet weak var pendingEventsTableView: UITableView!
    
    var user = User()
    var pendingEvents = [UserEvent]()
    var pendingEventsDictionary = [String: UserEvent]()
    let cellId = "cellId"
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        // TODO: Need to fix translucency problems
        navigationController?.navigationBar.isTranslucent = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        observePendingEvents()
    }
    
    func setupTableView() {
        pendingEventsTableView.delegate = self
        pendingEventsTableView.dataSource = self
        pendingEventsTableView.register(UserEventCell.self, forCellReuseIdentifier: cellId)
        
        pendingEvents.removeAll()
        pendingEventsDictionary.removeAll()
        pendingEventsTableView.reloadData()
    }
    
    func observePendingEvents() {
        
        // TODO: Implement a check so that all events except the user's displays in pending events
        
        let ref = Database.database().reference().child("pending_events")
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
                self.pendingEventsDictionary[eventId] = event
                self.handleReloadTable()
            }
        }, withCancel: nil)
    }
    
    func createEventFromDictionary(_ dictionary: [String: AnyObject]) -> UserEvent {
         let event = UserEvent()
         var imageUrl = String()

         createUserFromDictionary(dictionary)

         event.user = user
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

     func createUserFromDictionary(_ dictionary: [String: AnyObject]) {
         user.firstName = dictionary["user_first_name"] as? String
         user.lastName = dictionary["user_last_name"] as? String
         user.major = dictionary["user_major"] as? String
         user.academicYear = dictionary["user_academic_year"] as? String
         user.sjsuId = dictionary["user_sjsu_id"] as? String
     }

     func handleReloadTable() {
         self.pendingEvents = Array(self.pendingEventsDictionary.values)
         self.pendingEvents.sort { (event1, event2) -> Bool in
            // TODO: Sort by time of submission
            return event1.eventType! < event2.eventType!
        }
        
        DispatchQueue.main.async {
            self.pendingEventsTableView.reloadData()
        }
    }
    
    @IBAction func doneWithPendingEvents(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
}

extension PendingEventsViewController: UITableViewDelegate, UITableViewDataSource {
   
   func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return pendingEvents.count
   }
   
   func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       return 72
   }
   
   func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! UserEventCell
       
       let event = pendingEvents[indexPath.row]
       cell.event = event
       
       return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailVC = storyboard?.instantiateViewController(withIdentifier: "PendingEventDetailViewController") as! PendingEventDetailViewController
        let event = pendingEvents[indexPath.item]

        detailVC.event = event

        navigationController?.pushViewController(detailVC, animated: true)
    }

}
