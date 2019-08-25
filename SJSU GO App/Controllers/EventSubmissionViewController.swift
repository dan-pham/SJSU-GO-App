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
    
    var user = User()
    var userEvent = UserEvent()
    var adminEvent = AdminEvent()
    
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
        configureTextField()
        configureTextView()
        configureImageView()
        configurePickerView()
        
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        
        setupUserForUserEvent()
        
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
    
    func setupUserForUserEvent() {
        let uid = Auth.auth().currentUser!.uid
        let ref = Database.database().reference().child("users").child(uid)
        ref.observeSingleEvent(of: .value) { (snapshot) in
            
            if let dictionary = snapshot.value as? [String: AnyObject] {
                self.user.firstName = dictionary["first_name"] as? String
                self.user.lastName = dictionary["last_name"] as? String
                self.user.major = dictionary["major"] as? String
                self.user.email = dictionary["sjsu_email"] as? String
                self.user.academicYear = dictionary["academic_year"] as? String
                self.user.sjsuId = dictionary["sjsu_id"] as? String
            }
        }
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
        
        let image = imageView.image!
        uploadImageToFirebaseStorage(image) { (imageUrl) in
            self.saveUserEventWithImageUrl(imageUrl)
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func uploadImageToFirebaseStorage(_ image: UIImage, completion: @escaping (_ imageUrl: String) -> ()) {
        let imageName = UUID().uuidString
        let ref = Storage.storage().reference().child("user_event_images").child(imageName)
        
        if let uploadData = image.jpegData(compressionQuality: 0.5) {
            ref.putData(uploadData, metadata: nil) { (metadata, error) in
                if error != nil {
                    print("Failed to upload image: ", error!.localizedDescription)
                    return
                }
                
                ref.downloadURL(completion: { (url, err) in
                    if let err = err {
                        print("Failed to download from URL: ", err)
                        return
                    }
                    
                    completion(url?.absoluteString ?? "")
                })
            }
        }
    }
    
    func saveUserEventWithImageUrl(_ imageUrl: String) {
        let ref = Database.database().reference().child("events")
        let childRef = ref.childByAutoId()
        let userId = Auth.auth().currentUser!.uid
        
        userEvent.user = user
        userEvent.eventType = eventTypeTextField.text
        userEvent.eventDescription = eventDescriptionTextView.text
        userEvent.points = adminEvent.points
        userEvent.isApprovedByAdmin = false
        userEvent.id = childRef.key
        
        // Event attributes
        var values: [String: AnyObject] = ["id": userEvent.id as AnyObject, "user_first_name": userEvent.user?.firstName as AnyObject, "user_last_name": userEvent.user?.lastName as AnyObject, "user_major": userEvent.user?.major as AnyObject, "user_email": userEvent.user?.email as AnyObject, "user_academic_year": userEvent.user?.academicYear as AnyObject, "user_sjsu_id": userEvent.user?.sjsuId as AnyObject, "event_type": userEvent.eventType as AnyObject, "event_description": userEvent.eventDescription as AnyObject, "points": userEvent.points as AnyObject, "is_approved_by_admin": userEvent.isApprovedByAdmin as AnyObject]
        
        // Image attribute
        let properties: [String: AnyObject] = ["image_url": imageUrl as AnyObject]
        
        properties.forEach({values[$0] = $1})
        
        childRef.updateChildValues(values) { (error, ref) in
            if let error = error {
                print("Error updating child values for favorites: ", error)
                return
            }
            
            let userEventsRef = Database.database().reference().child("user_events").child(userId).child(self.userEvent.id!)
            userEventsRef.setValue(1)
        }
    }
    
    
    
}
