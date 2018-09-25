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
  
  //private var state = PictureTakenState.hasNotTakenPicture
  
  private var imagePicker = UIImagePickerController()
  private let operationQueue: OperationQueue = {
    let oq = OperationQueue()
    oq.name = "TakePictureVC OperationQueue"
    return oq
  }()
  var networkManager: NetworkManager?
  var image: UIImage?
  
  init(networkManager: NetworkManager) {
    self.networkManager = networkManager
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    shootPhoto()
  }
  
  
  // Take a picture and get the location that the photo was taken at.  Pass these to the network manager upon completion
  // Should add a completion to the end of this group/operation to pop this ViewController
  private func shootPhoto() {
    let requestCameraAccessOp = RequestCameraAccessOperation()
    let requestLocationWhenInUseOp = RequestLocationWhenInUseOperation()
    
    let takePictureOp = TakePictureOperation(viewController: self)
    
    let locationOp = LocationOperation()
    locationOp.completionBlock = { [weak networkManager, unowned self] in
      let post = Post(uuid: UUID(), image: takePictureOp.image!, location: locationOp.location!)
      networkManager?.upload(post: post)
      self.dismiss(animated: true, completion: nil)
    }
    
    requestLocationWhenInUseOp.addDependency(requestCameraAccessOp)
    takePictureOp.addDependency(requestLocationWhenInUseOp)
    locationOp.addDependency(takePictureOp)

//    let operationGroup = OperationGroup()
//    operationGroup.add(
//      operations: [requestCameraAccessOp,
//                   requestLocationWhenInUseOp,
//                   takePictureOp,
//                   locationOp])
//    operationGroup.finishingOperation = BlockOperation { [weak networkManager] in
//      let post = Post(uuid: UUID(), image: takePictureOp.image!, location: locationOp.location!)
//      networkManager?.upload(post: post)
//    }
    
    //operationQueue.addOperation(operationGroup)
    
    operationQueue.addOperations([requestCameraAccessOp,
                                  requestLocationWhenInUseOp,
                                  takePictureOp,
                                  locationOp],
                                 waitUntilFinished: false)
    
  }
  
//  func alertUserNoCamera() {
//    let alertVC = UIAlertController(title: "No Camera", message: "This device does not have a camera", preferredStyle: .alert)
//    let okAction = UIAlertAction(title: "OK", style: .default) { alertAction in
//      self.dismiss(animated: true, completion: nil)
//    }
//    alertVC.addAction(okAction)
//    present(alertVC, animated: true, completion: nil)
//  }
//
//  func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
//    state = .canceled
//    dismiss(animated: true, completion: nil)
//  }
//
//
//  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
//    state = .hasTakenPicture
//    image = info[UIImagePickerControllerOriginalImage] as? UIImage
//      //networkManager?.uploadImageToStorage(image)
//    dismiss(animated: true, completion: nil)
//  }
  
}
