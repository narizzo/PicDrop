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

fileprivate enum State {
  case needsPicture
  case hasPicture
  case canceled
}

class TakePictureViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, CLLocationManagerDelegate {
  private var imagePicker = UIImagePickerController()
  private var state: State = State.needsPicture
  private let photoManager = PhotoManager()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    LocationManager.shared.locationManager.delegate = self
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    // Either take picture or dismiss this VC
    switch state {
    case .needsPicture:
      verifyPhotoAuth()
    case .canceled:
      fallthrough
    default:
      dismiss(animated: true, completion: nil)
    }
  }
  
  private func verifyPhotoAuth() {
    if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
      //locationManager.delegate = self
      shootPhoto()
    } else {
      LocationManager.shared.locationManager.requestWhenInUseAuthorization()
    }
  }
  
  func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
    if status == .authorizedWhenInUse {
      shootPhoto()
    }
  }
  
  private func shootPhoto() {
    LocationManager.shared.locationManager.startUpdatingLocation()
    
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
    let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
    alertVC.addAction(okAction)
    present(alertVC, animated: true, completion: nil)
  }
  
  func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
    state = .canceled
    dismiss(animated: true, completion: nil)
  }
  
  
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
    LocationManager.shared.locationManager.stopUpdatingLocation()
    state = .hasPicture
    if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
      guard let location = LocationManager.shared.locationManager.location else {
        print("Error: Location not valid")
        return
      }
      photoManager.upload(photo: image, location: location)
    }
    dismiss(animated: true, completion: nil)
  }
  
}
