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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupEventDetails()
    }
    
    func setupEventDetails() {
        if let user = event.user {
            nameLabel.text = "\(user.firstName!) \(user.lastName!)"
            majorLabel.text = user.major
            idLabel.text = user.sjsuId
        }
        
        eventTypeLabel.text = event.eventType
        eventDescriptionTextView.text = event.eventDescription
        
        imageView.image = event.image
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleZoomTap)))
    }
    
    @IBAction func approveEvent(_ sender: Any) {
        Alerts.showApproveAlertVC(on: self, action: (UIAlertAction(title: "Approve", style: .default) {_ in
            self.handleApproveEvent()
        }))
    }
    
    func handleApproveEvent() {
        print("Accept")
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func rejectEvent(_ sender: Any) {
        Alerts.showRejectAlertVC(on: self, action: (UIAlertAction(title: "Reject", style: .default) {_ in
            self.handleRejectEvent()
        }))
    }
    
    func handleRejectEvent() {
        print("Reject")
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func cancel(_ sender: Any) {
        navigationController?.popViewController(animated: true)
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
