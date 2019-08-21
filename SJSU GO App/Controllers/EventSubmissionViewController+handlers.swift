//
//  EventSubmissionViewController+handlers.swift
//  SJSU GO App
//
//  Created by Dan Pham on 8/20/19.
//  Copyright © 2019 Dan Pham. All rights reserved.
//

import UIKit

// MARK: - UITextFieldDelegate

extension EventSubmissionViewController: UITextFieldDelegate {
    func delegateTextField() {
        eventTypeTextField.delegate = self
    }
    
    func clearTextField() {
        eventTypeTextField.text = ""
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if (textField == eventTypeTextField) {
            pickerView.reloadAllComponents()
            pickerView.isHidden = false
            textField.endEditing(true)
        } else {
            pickerView.isHidden = true
        }
    }
}

// MARK: - UITextViewDelegate

extension EventSubmissionViewController: UITextViewDelegate {
    
    func configureTextView() {
        eventDescriptionTextView.delegate = self
        eventDescriptionTextView.text = "Enter event description..."
        eventDescriptionTextView.textColor = UIColor.lightGray
        addBorderLinesToTextView()
    }
    
    func addBorderLinesToTextView() {
        let topLineView = UIView()
        configureLineView(lineView: topLineView)
        topLineView.leftAnchor.constraint(equalTo: eventDescriptionTextView.leftAnchor).isActive = true
        topLineView.bottomAnchor.constraint(equalTo: eventDescriptionTextView.topAnchor).isActive = true
        topLineView.widthAnchor.constraint(equalTo: eventDescriptionTextView.widthAnchor).isActive = true
        topLineView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        let bottomLineView = UIView()
        configureLineView(lineView: bottomLineView)
        bottomLineView.leftAnchor.constraint(equalTo: eventDescriptionTextView.leftAnchor).isActive = true
        bottomLineView.topAnchor.constraint(equalTo: eventDescriptionTextView.bottomAnchor).isActive = true
        bottomLineView.widthAnchor.constraint(equalTo: eventDescriptionTextView.widthAnchor).isActive = true
        bottomLineView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        let leftLineView = UIView()
        configureLineView(lineView: leftLineView)
        leftLineView.leftAnchor.constraint(equalTo: eventDescriptionTextView.leftAnchor).isActive = true
        leftLineView.topAnchor.constraint(equalTo: eventDescriptionTextView.topAnchor).isActive = true
        leftLineView.widthAnchor.constraint(equalToConstant: 1).isActive = true
        leftLineView.heightAnchor.constraint(equalTo: eventDescriptionTextView.heightAnchor).isActive = true
        
        let rightLineView = UIView()
        configureLineView(lineView: rightLineView)
        rightLineView.rightAnchor.constraint(equalTo: eventDescriptionTextView.rightAnchor).isActive = true
        rightLineView.topAnchor.constraint(equalTo: eventDescriptionTextView.topAnchor).isActive = true
        rightLineView.widthAnchor.constraint(equalToConstant: 1).isActive = true
        rightLineView.heightAnchor.constraint(equalTo: eventDescriptionTextView.heightAnchor).isActive = true
    }
    
    func configureLineView(lineView: UIView) {
        lineView.backgroundColor = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1)
        lineView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(lineView)
    }
    
    func clearTextView() {
        eventDescriptionTextView.text = ""
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if !isOtherEventSelected {
            textView.textColor = UIColor.black
            textView.endEditing(true)
        } else if textView.textColor == UIColor.lightGray {
            textView.text = ""
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Enter event description..."
            textView.textColor = UIColor.lightGray
        }
        textView.resignFirstResponder()
    }
    
}

// MARK: - UIImagePickerControllerDelegate & UINavigationControllerDelegate

extension EventSubmissionViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func configureImageView() {
        imageView.isHidden = true
        imageView.contentMode = .scaleAspectFill
    }
    
    func pick(sourceType: UIImagePickerController.SourceType) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imageView.image = image
            imageView.isHidden = false
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
}

// MARK: - UIPickerViewDelegate

extension EventSubmissionViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func configurePickerView() {
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView.isHidden = true
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return eventsWithOtherOption.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return eventsWithOtherOption[row].eventType
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        eventTypeTextField.text = eventsWithOtherOption[row].eventType
        
        if (eventTypeTextField.text == "Other") {
            isOtherEventSelected = true
            eventDescriptionTextView.text = ""
        } else {
            isOtherEventSelected = false
            eventDescriptionTextView.text = eventsWithOtherOption[row].eventDescription
            adminEvent.points = eventsWithOtherOption[row].points
            eventDescriptionTextView.endEditing(true)
        }
        
        perform(#selector(hidePickerView), with: nil, afterDelay: 1)
    }
    
    @objc func hidePickerView() {
        pickerView.isHidden = true
    }
    
}
