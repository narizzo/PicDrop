//
//  TakePictureViewController.swift
//  PicDrop
//
//  Created by Nicholas Rizzo on 6/24/18.
//  Copyright © 2018 Nicholas Rizzo. All rights reserved.
//

import UIKit
import CoreLocation
import FirebaseStorage
import FirebaseDatabase
import FirebaseAuth

fileprivate enum PictureTakenState {
  case hasNotTakenPicture
  case hasTakenPicture
  case canceled
}

class TakePictureViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  
  private var imagePicker = UIImagePickerController()
  private var state = PictureTakenState.hasNotTakenPicture
  var networkManager: NetworkManager?
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    // Either take picture or dismiss this VC
    switch state {
    case .hasNotTakenPicture:
      verifyPhotoAuth()
    case .canceled:
      fallthrough
    default:
      dismiss(animated: true, completion: nil)
    }
  }
  
  private func verifyPhotoAuth() {
    if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
      shootPhoto()
    } else {
      LocationSingleton.shared.locationManager.requestWhenInUseAuthorization()
    }
  }
  
  func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
    verifyPhotoAuth()
  }
  
  private func shootPhoto() {
    if UIImagePickerController.isSourceTypeAvailable(.camera) {
      imagePicker.delegate = self
      imagePicker.sourceType = .camera;
      imagePicker.cameraFlashMode = .off
      imagePicker.allowsEditing = false
      
      self.present(imagePicker, animated: true, completion: nil)
    } else {
      alertUserNoCamera()
    }
  }
  
  func alertUserNoCamera() {
    let alertVC = UIAlertController(title: "No Camera", message: "This device does not have a camera", preferredStyle: .alert)
    let okAction = UIAlertAction(title: "OK", style: .default) { alertAction in
      self.dismiss(animated: true, completion: nil)
    }
    alertVC.addAction(okAction)
    present(alertVC, animated: true, completion: nil)
  }
  
  func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
    state = .canceled
    dismiss(animated: true, completion: nil)
  }
  
  
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
    state = .hasTakenPicture
    if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
      //networkManager?.uploadPhotoToStorage(photo: image)
    }
    dismiss(animated: true, completion: nil)
  }
  
}
