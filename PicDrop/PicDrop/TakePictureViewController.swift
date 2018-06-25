//
//  TakePictureViewController.swift
//  PicDrop
//
//  Created by Nicholas Rizzo on 6/24/18.
//  Copyright © 2018 Nicholas Rizzo. All rights reserved.
//

import UIKit
import MapKit

fileprivate enum State {
  case needsPicture
  case hasPicture
}

class TakePictureViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, CLLocationManagerDelegate {
  
  @IBOutlet weak var photo: UIImageView!
  
  private var locationManager = CLLocationManager()
  private var imagePicker = UIImagePickerController()
  
  private var state: State = State.needsPicture
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    // Either take picture or dismiss this VC
    switch state {
    case .needsPicture:
      verifyPhotoAuth()
    default:
      dismiss(animated: true, completion: nil)
    }
  }
  
  private func verifyPhotoAuth() {
    if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
      locationManager.delegate = self
      shootPhoto()
    } else {
      locationManager.requestWhenInUseAuthorization()
    }
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
    let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
    alertVC.addAction(okAction)
    present(alertVC, animated: true, completion: nil)
  }
  
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
    
    state = .hasPicture
    
    let image = info[UIImagePickerControllerOriginalImage] as! UIImage
    photo.image = image
    
    // need to loop until location is accurate
    locationManager.desiredAccuracy = kCLLocationAccuracyBest
    locationManager.startUpdatingLocation()
    
    if let location = locationManager.location {
      print("location: \(location.coordinate.latitude) by \(location.coordinate.longitude)")
      locationManager.stopUpdatingLocation()
      
    }
    dismiss(animated: true, completion: nil)
  }
  
}
