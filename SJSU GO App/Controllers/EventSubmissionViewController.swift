//
//  EventSubmissionViewController.swift
//  SJSU GO App
//
//  Created by Dan Pham on 8/19/19.
//  Copyright © 2019 Dan Pham. All rights reserved.
//

import UIKit
import Firebase

class EventSubmissionViewController: UIViewController {
    
    var eventsWithoutOtherOption = [AdminEvent]()
    var eventsWithOtherOption = [AdminEvent]()
    var isOtherEventSelected = Bool()
    
    @IBOutlet weak var eventTypeTextField: UITextField!
    @IBOutlet weak var eventDescriptionTextView: UITextView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegateTextField()
        configureTextView()
        configureImageView()
        configurePickerView()
        
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        
        setupSampleAdminEvents()
    }
    
    func setupSampleAdminEvents() {
        SampleAdminEvents.sharedInstance.setupAdminEvents()
        eventsWithoutOtherOption = SampleAdminEvents.sharedInstance.adminEvents
        eventsWithOtherOption = appendOtherEventOption(events: eventsWithoutOtherOption)
    }
    
    func appendOtherEventOption(events: [AdminEvent]) -> [AdminEvent] {
        let oldEvents = events
        var newEvents = oldEvents
        
        let otherEvent = AdminEvent()
        otherEvent.eventType = "Other"
        newEvents.append(otherEvent)
        
        return newEvents
    }
    
    // To be efficient, maybe only allow user to submit images. User can screenshot proof if necessary
    @IBAction func pickImageFromAlbum(_ sender: Any) {
        pick(sourceType: .photoLibrary)
    }
    
    @IBAction func takePictureWithCamera(_ sender: Any) {
        pick(sourceType: .camera)
    }
    
    @IBAction func cancelEventSubmission(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func submitEvent(_ sender: Any) {
        guard eventTypeTextField.hasText, eventDescriptionTextView.hasText, imageView.image != nil else {
            print("Enter the event type and description, and upload a photo of proof")
            return
        }
        
        // Post event to Firebase
        
        
        navigationController?.popViewController(animated: true)
    }
    
}
