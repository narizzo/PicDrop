//
//  RequestCameraAccessOperation.swift
//  PicDrop
//
//  Created by Nicholas Rizzo on 9/23/18.
//  Copyright © 2018 Nicholas Rizzo. All rights reserved.
//

/* Abstract:
 RequestCameraAccessOperation does 2 things. It checks that the device has a camera, and it checks the authorization status for access to the camera.  This operation will spawn another operation to request camera access if the status is not determined.  Otherwise it will spawn an operation to alert the user and give them the option to follow a deep link to their settings to change the authorization.
 */

import UIKit
import AVFoundation

class RequestCameraAccessOperation: Operation {
  
  let imagePicker = UIImagePickerController()
  // error property
  var error: OperationError?
  
  override init() {
    super.init()
    print("RequestCameraAccess Operation init")
    completionBlock = { [weak self] in
      if let _ = self?.error {
        // alertUserOperation(with: error)  // put 'error checker' in operation queue to present this error from a single place instead of presenting error from this or some other operation
        self?.cancel()
      }
    }
  }
  
  override func main() {
    if isCancelled { return }
    
    let available = UIImagePickerController.isSourceTypeAvailable(.camera)
    let status = AVCaptureDevice.authorizationStatus(for: .video)
    
    switch (available, status) {
    case (false, _):
      error = .failed("This device does not have a camera")
    case (true, .authorized):
      break
    case (true, .notDetermined):
      AVCaptureDevice.requestAccess(for: .video) { accessGranted in
        if !accessGranted {
          // set error
        }
      }
    case (true, _):
      error = .failed("PicDrop is not authorized to use this device's camera")
    }
    
    if let error = error {
      print("Alert Mockup: \(error.localizedDescription)")
    }
  }
  
}
