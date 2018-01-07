//
//  ScanQrViewController.swift
//  WhereAreMyFries
//
//  Created by Pieter-Jan Philips on 28/12/2017.
//  Copyright © 2017 Pieter-Jan Philips. All rights reserved.
//

import UIKit
import AVFoundation
import CloudKit

class ScanQrViewController: UIViewController {

    @IBOutlet weak var cancelBTN: UIButton!
    @IBOutlet weak var messageLabel: UILabel!
    
    var captureSession = AVCaptureSession()
    
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    var qrCodeFrameView: UIView?
    
    private let supportedCodeTypes = [AVMetadataObject.ObjectType.qr]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cancelBTN.backgroundColor = UIColor.white
        cancelBTN.layer.cornerRadius = 10

        
        // Get the back-facing camera for capturing videos
        let deviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: AVMediaType.video, position: .back)
        
        guard let captureDevice = deviceDiscoverySession.devices.first else {
            print("Failed to get the camera device")
            return
        }
        
        do {
            // Get an instance of the AVCaptureDeviceInput class using the previous device object.
            let input = try AVCaptureDeviceInput(device: captureDevice)
            
            // Set the input device on the capture session.
            captureSession.addInput(input)
            
            // Initialize a AVCaptureMetadataOutput object and set it as the output device to the capture session.
            let captureMetadataOutput = AVCaptureMetadataOutput()
            captureSession.addOutput(captureMetadataOutput)
            
            // Set delegate and use the default dispatch queue to execute the call back
            captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            captureMetadataOutput.metadataObjectTypes = supportedCodeTypes
            //            captureMetadataOutput.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]
            
        } catch {
            // If any error occurs, simply print it out and don't continue any more.
            print(error)
            return
        }
        
        // Initialize the video preview layer and add it as a sublayer to the viewPreview view's layer.
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        videoPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        videoPreviewLayer?.frame = view.layer.bounds
        view.layer.addSublayer(videoPreviewLayer!)
        
        // Start video capture.
        captureSession.startRunning()
        
        // Move the message label and top bar to the front
        view.bringSubview(toFront: cancelBTN)
        view.bringSubview(toFront: messageLabel)
        
        // Initialize QR Code Frame to highlight the QR code
        qrCodeFrameView = UIView()
        
        if let qrCodeFrameView = qrCodeFrameView {
            qrCodeFrameView.layer.borderColor = UIColor.green.cgColor
            qrCodeFrameView.layer.borderWidth = 2
            view.addSubview(qrCodeFrameView)
            view.bringSubview(toFront: qrCodeFrameView)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Helper methods
    func launchApp(decodedURL: String) {
        
        if presentedViewController != nil {
            return
        }
        
        var alertprompt = UIAlertController()
        
        BestellingenRepository().getRecordBy(recordName: decodedURL, gotRecord: { record in
            
            if let record = record {
                
                print("\(record)")
                
                alertprompt = UIAlertController(title: "Found List:",
                                                message: "Do you want to subscribe to list: \(record.object(forKey: "name") as! String)",
                                                preferredStyle: .actionSheet)
                
                let confirmAction = UIAlertAction(title: "Confirm", style: UIAlertActionStyle.default, handler: { (action) -> Void in
                    BestellingenRepository().subscribeTo(BestellingRecord: record, completionHandler: { (succes, message) in
                        DispatchQueue.main.async {
                            self.messageLabel.text = "\(succes): \(message)"
                            
                            if succes == true {
                                self.performSegue(withIdentifier: "scansucceeded", sender: Any?.self)
                            }
                            
                        }
                    })
                    
                })
                
                alertprompt.addAction(confirmAction)
                
                let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: { (action) -> Void in
                    self.captureSession.startRunning()
                })
                
                alertprompt.addAction(cancelAction)
                
                self.present(alertprompt, animated: true, completion: nil)
                self.captureSession.stopRunning()
                
            } else {
                alertprompt = UIAlertController(title: "Did not found list", message: "Did not found list: \(decodedURL)", preferredStyle: .actionSheet)
            }
            
        })
        
        
    }
    
}

extension ScanQrViewController: AVCaptureMetadataOutputObjectsDelegate {
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        // Check if the metadataObjects array is not nil and it contains at least one object.
        if metadataObjects.count == 0 {
            qrCodeFrameView?.frame = CGRect.zero
            return
        }
        
        // Get the metadata object.
        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        
        if supportedCodeTypes.contains(metadataObj.type) {
            // If the found metadata is equal to the QR code metadata (or barcode) then update the status label's text and set the bounds
            let barCodeObject = videoPreviewLayer?.transformedMetadataObject(for: metadataObj)
            qrCodeFrameView?.frame = barCodeObject!.bounds
            
            if metadataObj.stringValue != nil {
                launchApp(decodedURL: metadataObj.stringValue!)
            }
        }
    }
    
}