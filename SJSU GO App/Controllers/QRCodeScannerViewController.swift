//
//  QRCodeScannerViewController.swift
//  SJSU GO App
//
//  Created by Dan Pham on 8/23/19.
//  Copyright © 2019 Dan Pham. All rights reserved.
//

import UIKit
import Firebase
import AVFoundation

class QRCodeScannerViewController: UIViewController {
    
    var video = AVCaptureVideoPreviewLayer()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        // TODO: Need to fix translucency problems
        self.navigationController?.navigationBar.isTranslucent = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createAVCaptureSession()
    }
    
    func createAVCaptureSession() {
        // Creating session
        let session = AVCaptureSession()
        
        defineCaptureDevice(session: session)
        defineMetadataOutput(session: session)
        defineVideoPreviewLayer(session: session)
        
//        self.view.bringSubviewToFront(navigationController!.navigationBar)
        
        session.startRunning()
    }
    
    func defineCaptureDevice(session: AVCaptureSession) {
        // Define capture device
        guard let captureDevice = AVCaptureDevice.default(for: .video) else {
            Alerts.showNoCaptureDeviceFoundAlertVC(on: self)
            return
        }
        
        do {
            let input = try AVCaptureDeviceInput(device: captureDevice)
            session.addInput(input)
        } catch {
            Alerts.showAddingSessionInputFailedAlertVC(on: self)
        }
    }
    
    func defineMetadataOutput(session: AVCaptureSession) {
        let output = AVCaptureMetadataOutput()
        session.addOutput(output)
        output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        output.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]
    }
    
    func defineVideoPreviewLayer(session: AVCaptureSession) {
        video = AVCaptureVideoPreviewLayer(session: session)
        video.frame = view.layer.bounds
        view.layer.addSublayer(video)
    }
    
    @IBAction func doneWithQRCodeScanner(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
}

extension QRCodeScannerViewController: AVCaptureMetadataOutputObjectsDelegate {
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        
        if metadataObjects.count != 0 {
            if let object = metadataObjects[0] as? AVMetadataMachineReadableCodeObject {
                if object.type == AVMetadataObject.ObjectType.qr {
                    if let sjsuId = object.stringValue {
                        presentAlert(sjsuId: sjsuId)
                    }
                }
            }
        }
    }
    
    func presentAlert(sjsuId: String) {
        let message = "SJSU ID: \(sjsuId)"
        
        let alert = UIAlertController(title: "QR Code Scanner", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Approve User", style: .default, handler: { (alertAction) in
            
            // TODO: Approve user event in firebase
            print("Approve user event in firebase")
        }))
        
        present(alert, animated: true, completion: nil)
    }
}
