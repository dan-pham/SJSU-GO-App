//
//  PendingEventDetailViewController.swift
//  SJSU GO App
//
//  Created by Dan Pham on 9/11/19.
//  Copyright © 2019 Dan Pham. All rights reserved.
//

import UIKit
import Firebase

class PendingEventDetailViewController: UIViewController {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var majorLabel: UILabel!
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var academicYearLabel: UILabel!
    
    @IBOutlet weak var eventTypeLabel: UILabel!
    @IBOutlet weak var eventDescriptionTextView: UITextView!
    @IBOutlet weak var imageView: UIImageView!
    
    var event = UserEvent()
    var startingImageView: UIImageView?
    var blackBackgroundView: UIView?
    var startingFrame: CGRect?
    
    let activityIndicator = ActivityIndicator()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupEventDetails()
    }
    
    func setupEventDetails() {
        if let user = event.user {
            nameLabel.text = "\(user.firstName!) \(user.lastName!)"
            majorLabel.text = user.major
            idLabel.text = user.sjsuId
            academicYearLabel.text = user.academicYear
        }
        
        eventTypeLabel.text = event.eventType
        eventDescriptionTextView.text = event.eventDescription
        
        imageView.image = event.image
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleZoomTap)))
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func approveEvent(_ sender: Any) {
        Alerts.showApproveAlertVC(on: self, action: (UIAlertAction(title: "Approve", style: .default) {_ in
            self.handleApproveEvent()
        }))
    }
    
    func handleApproveEvent() {
        activityIndicator.showActivityIndicator()
        handleUpdateUserEventStatus(isApproved: true)
        activityIndicator.hideActivityIndicator()
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func rejectEvent(_ sender: Any) {
        Alerts.showRejectAlertVC(on: self, action: (UIAlertAction(title: "Reject", style: .default) {_ in
            self.handleRejectEvent()
        }))
    }
    
    func handleRejectEvent() {
        activityIndicator.showActivityIndicator()
        handleUpdateUserEventStatus(isApproved: false)
        activityIndicator.hideActivityIndicator()
        navigationController?.popViewController(animated: true)
    }
    
    func handleUpdateUserEventStatus(isApproved: Bool) {
        if (isApproved) {
            updateStatusInEvents(event.id!, isApprovedByAdmin: "Approved")
            calculateUserPointsFromFirebase()
            removeEventFromPendingEvents(event.id!)
        } else {
            updateStatusInEvents(event.id!, isApprovedByAdmin: "Rejected")
            removeEventFromPendingEvents(event.id!)
        }
    }
    
    func updateStatusInEvents(_ eventId: String, isApprovedByAdmin: String) {
        let ref = Database.database().reference()
        let eventReference = ref.child("events").child(eventId)
        let values = ["is_approved_by_admin" : isApprovedByAdmin]

        eventReference.updateChildValues(values) { (err, ref) in
            if let err = err {
                self.activityIndicator.hideActivityIndicator()
                Alerts.showUpdateFailedAlertVC(on: self, message: err.localizedDescription)
                return
            }
        }
    }

    func removeEventFromPendingEvents(_ eventId: String) {
        Database.database().reference().child("pending_events").child(eventId).removeValue { (error, ref) in
            if error != nil {
                self.activityIndicator.hideActivityIndicator()
                Alerts.showRemoveEventFailedAlertVC(on: self, message: error!.localizedDescription)
                return
            }
        }
    }

    func calculateUserPointsFromFirebase() {
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }

        let userReference = Database.database().reference().child("users").child(uid)
        userReference.observeSingleEvent(of: .value, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject] {
                let userPoints = dictionary["points"] as? Int ?? 0
                let points: Int = userPoints + self.event.points!
                self.handleUpdateUserPoints(uid, points: points)
            }
        }, withCancel: nil)
    }

    func handleUpdateUserPoints(_ uid: String, points: Int) {
        let ref = Database.database().reference()
        let userReference = ref.child("users").child(uid)
        let values = ["points" : points]

        userReference.updateChildValues(values) { (err, ref) in
            if let err = err {
                self.activityIndicator.hideActivityIndicator()
                Alerts.showUpdateFailedAlertVC(on: self, message: err.localizedDescription)
                return
            }
        }
    }
    
}

extension PendingEventDetailViewController {
    
    @objc func handleZoomTap(tapGesture: UITapGestureRecognizer) {
        if let imageView = tapGesture.view as? UIImageView {
            performZoomInForStartingImageView(imageView)
        }
    }
    
    func performZoomInForStartingImageView(_ startingImageView: UIImageView) {
        self.startingImageView = startingImageView
        self.startingImageView?.isHidden = true
        
        startingFrame = startingImageView.superview?.convert(startingImageView.frame, to: nil)
        
        let zoomingImageView = UIImageView(frame: startingFrame!)
        zoomingImageView.contentMode = .scaleAspectFit
        zoomingImageView.image = startingImageView.image
        zoomingImageView.isUserInteractionEnabled = true
        zoomingImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleZoomOut)))
        
        if let keyWindow = UIApplication.shared.keyWindow {
            
            blackBackgroundView = UIView(frame: keyWindow.frame)
            blackBackgroundView?.backgroundColor = UIColor.black
            blackBackgroundView?.alpha = 0
            
            keyWindow.addSubview(blackBackgroundView!)
            keyWindow.addSubview(zoomingImageView)
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                
                self.blackBackgroundView?.alpha = 1
                
                // h2 / w2 = h1 / w1 => h2 = h1 / w1 * w2
                let height = self.startingFrame!.height / self.startingFrame!.width * keyWindow.frame.height
                
                zoomingImageView.frame = CGRect(x: 0, y: 0, width: keyWindow.frame.width, height: height)
                
                zoomingImageView.center = keyWindow.center
                
            }, completion: nil)
        }
    }
    
    @objc func handleZoomOut(_ tapGesture: UITapGestureRecognizer) {
        if let zoomOutImageView = tapGesture.view {
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                
                zoomOutImageView.contentMode = .scaleAspectFit
                zoomOutImageView.frame = self.startingFrame!
                self.blackBackgroundView?.alpha = 0
                
            }) { (completed: Bool) in
                zoomOutImageView.removeFromSuperview()
                self.startingImageView?.isHidden = false
            }
        }
    }
    
}
