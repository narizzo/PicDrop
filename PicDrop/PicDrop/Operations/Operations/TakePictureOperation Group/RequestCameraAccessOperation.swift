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
  var error: AVError.Code?
  
  override func main() {
    print("RequestCameraAccess main")
    if isCancelled {
      return
    }
    
    let available = UIImagePickerController.isSourceTypeAvailable(.camera)
    let status = AVCaptureDevice.authorizationStatus(for: .video)
  
    switch (available, status) {
    case (false, _):
      //error = .failed("This device does not have a camera")
      error = AVError.contentIsUnavailable
    case (true, .authorized):
      break
    case (true, .notDetermined):
      AVCaptureDevice.requestAccess(for: .video) { accessGranted in
        if !accessGranted {
          self.error = AVError.applicationIsNotAuthorizedToUseDevice
        }
      }
    case (true, _):
      error = AVError.unknown
    }
    self.cancel()
    
    
    print("RequestCameraAccess.isCancelled: \(isCancelled)")
//    if let error = error {
//      self.cancel()
//    }
  }
  
}
