//
//  PendingEventsViewController.swift
//  SJSU GO App
//
//  Created by Dan Pham on 8/23/19.
//  Copyright © 2019 Dan Pham. All rights reserved.
//

import UIKit
import Firebase

class PendingEventsViewController: UIViewController
{
    
    @IBOutlet weak var pendingEventsTableView: UITableView!
    
    var user = User()
    var pendingEvents = [UserEvent]()
    var pendingEventsDictionary = [String: UserEvent]()
    let cellId = "cellId"
    
    let activityIndicator = ActivityIndicator()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        // TODO: Need to fix translucency problems
        navigationController?.navigationBar.isTranslucent = false
        setupTableView()
        observePendingEvents()
     }

     override func viewDidLoad() {
        super.viewDidLoad()
        setBackgroundColors()
        setupTableView()
        observePendingEvents()
    }
    
    func setBackgroundColors() {
        Colors.setLightBlueColor(view: self.view)
        Colors.setWarmYellowColor(view: pendingEventsTableView)
    }
    
    func setupTableView() {
        pendingEventsTableView.delegate = self
        pendingEventsTableView.dataSource = self
        pendingEventsTableView.register(UserEventCell.self, forCellReuseIdentifier: cellId)
        pendingEventsTableView.addSubview(self.refreshControl)
        
        pendingEvents.removeAll()
        pendingEventsDictionary.removeAll()
        pendingEventsTableView.reloadData()
    }
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: UIControl.Event.valueChanged)
        return refreshControl
    }()
    
    @objc func handleRefresh(refreshControl: UIRefreshControl) {
        observePendingEvents()
        refreshControl.endRefreshing()
    }
    
    func observePendingEvents() {
        
        // TODO: Implement a check so that all events except the user's displays in pending events
        activityIndicator.showActivityIndicator(self)
        
        let ref = Database.database().reference().child("pending_events")
        ref.observe(.childAdded, with: { (snapshot) in
             let eventId = snapshot.key
             self.fetchEventWithEventId(eventId: eventId)
         }, withCancel: nil)

         ref.observe(.childRemoved, with: { (snapshot) in
             self.handleReloadTable()
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
        event.isApprovedByAdmin = dictionary["is_approved_by_admin"] as? String
        event.points = dictionary["points"] as? Int
        
        imageUrl = dictionary["image_url"] as? String ?? ""
        
        let imageView = UIImageView()
        imageView.loadImageUsingCacheWithUrlString(imageUrl) { (image) in
            DispatchQueue.main.async { event.image = image }
        }

        return event
    }
    
    func createUserFromDictionary(_ dictionary: [String: AnyObject]) {
        user.firstName = dictionary["user_first_name"] as? String
        user.lastName = dictionary["user_last_name"] as? String
        user.major = dictionary["user_major"] as? String
        user.academicYear = dictionary["user_academic_year"] as? String
        user.sjsuId = dictionary["user_sjsu_id"] as? String
        user.userId = dictionary["user_user_id"] as? String
     }
    
     func handleReloadTable() {
         self.pendingEvents = Array(self.pendingEventsDictionary.values)
         self.pendingEvents.sort { (event1, event2) -> Bool in
            // TODO: Sort by time of submission
            return event1.eventType! < event2.eventType!
        }
        
        DispatchQueue.main.async {
            self.pendingEventsTableView.reloadData()
            self.activityIndicator.hideActivityIndicator(self)
        }
    }
    
    @IBAction func settingsButtonPressed(_ sender: Any) {
        let adminSettingsVC = storyboard?.instantiateViewController(withIdentifier: "AdminSettingViewController") as! AdminSettingViewController
        
        navigationController?.pushViewController(adminSettingsVC, animated: true)
    }
    
    @IBAction func logOut(_ sender: Any) {
        do {
            try Auth.auth().signOut()
        } catch let signOutError {
            Alerts.showLogOutErrorAlertVC(on: self, message: signOutError.localizedDescription)
        }
            
        let loginNC = storyboard?.instantiateViewController(withIdentifier: "loginNavController")
        loginNC?.modalPresentationStyle = .fullScreen
        present(loginNC!, animated: true, completion: nil)
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
