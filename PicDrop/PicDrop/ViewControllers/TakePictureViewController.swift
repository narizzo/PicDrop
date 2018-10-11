//
//  TakePictureViewController.swift
//  PicDrop
//
//  Created by Nicholas Rizzo on 6/24/18.
//  Copyright © 2018 Nicholas Rizzo. All rights reserved.
//

import UIKit
import CoreLocation

class TakePictureViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  
  // MARK: - Injection
  private let networkManager: NetworkManager
  private let locationManager: CLLocationManager
  
  // MARK: - Properties
  private var imagePicker = UIImagePickerController()
  private let operationQueue: OperationQueue = {
    let oq = OperationQueue()
    oq.name = "TakePictureVC OperationQueue"
    return oq
  }()
  
  var image: UIImage?
  
  // MARK: - Init
  init(networkManager: NetworkManager, locationManager: CLLocationManager) {
    self.networkManager = networkManager
    self.locationManager = locationManager
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    shootPhoto()
  }
  
  
  // MARK: - Methods
  private func shootPhoto() {
    // Take a picture and get the location that the photo was taken at.  Pass these to the network manager upon completion
    
    // operations never execute...
//    let takePictureOpGroup = TakePictureOperationGroup(viewController: self, networkManager: networkManager, locationManager: locationManager)
//    operationQueue.addOperation(takePictureOpGroup)
    
    let requestCameraAccessOp = RequestCameraAccessOperation()
    let requestLocationWhenInUseOp = RequestLocationWhenInUseOperation()

    let takePictureOp = TakePictureOperation(viewController: self)

    let locationOp = GetLocationOperation()
    locationOp.completionBlock = { [weak networkManager, unowned self] in
      guard let image = takePictureOp.image
        //let location = locationOp.location else {
      else {
          self.dismiss(animated: true, completion: nil)
          return
      }
//      let post = Post(uuid: UUID(), image: image, location: location)
//      networkManager?.upload(post: post)
      self.dismiss(animated: true, completion: nil)
    }

    requestLocationWhenInUseOp.addDependency(requestCameraAccessOp)
    takePictureOp.addDependency(requestLocationWhenInUseOp)
    locationOp.addDependency(takePictureOp)

    operationQueue.addOperations([requestCameraAccessOp,
                                  requestLocationWhenInUseOp,
                                  takePictureOp,
                                  locationOp],
                                 waitUntilFinished: false)
  }
}
