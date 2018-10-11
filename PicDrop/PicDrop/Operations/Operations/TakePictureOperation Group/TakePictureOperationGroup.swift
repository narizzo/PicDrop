//
//  TakePictureOperationGroup.swift
//  PicDrop
//
//  Created by Nicholas Rizzo on 9/25/18.
//  Copyright © 2018 Nicholas Rizzo. All rights reserved.
//

import UIKit
import CoreLocation

class TakePictureOperationGroup: Operation {
  
  private var internalQueue = OperationQueue()
//  private lazy var completion: () -> Void = { [weak self]
//    if let error = error {
//      self?.cancel()
//    }
//  }
  
  init(viewController: UIViewController, networkManager: NetworkManager, locationManager: CLLocationManager) {
    super.init()
    let requestCameraAccessOp = RequestCameraAccessOperation()
    let requestLocationWhenInUseOp = RequestLocationWhenInUseOperation()
    
    let takePictureOp = TakePictureOperation(viewController: viewController)
    
    let locationOp = GetLocationOperation()
    locationOp.completionBlock = { [weak networkManager, weak viewController] in
      guard let image = takePictureOp.image else {
//        let location = locationOp.location else {
          viewController?.dismiss(animated: true, completion: nil)
          return
      }
//      let post = Post(uuid: UUID(), image: image, location: location)
//      networkManager?.upload(post: post)
      viewController?.dismiss(animated: true, completion: nil)
    }
    
    requestLocationWhenInUseOp.addDependency(requestCameraAccessOp)
    takePictureOp.addDependency(requestLocationWhenInUseOp)
    locationOp.addDependency(takePictureOp)
    
    internalQueue.addOperations([requestCameraAccessOp,
                                  requestLocationWhenInUseOp,
                                  takePictureOp,
                                  locationOp],
                                 waitUntilFinished: false)
  }
  
  override func cancel() {
    super.cancel()
    self.internalQueue.cancelAllOperations()
  }
}
