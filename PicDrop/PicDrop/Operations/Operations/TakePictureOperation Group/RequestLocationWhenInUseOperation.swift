//
//  RequestLocationWhenInUseOperation.swift
//  PicDrop
//
//  Created by Nicholas Rizzo on 9/21/18.
//  Copyright © 2018 Nicholas Rizzo. All rights reserved.
//

import Foundation
import CoreLocation

class RequestLocationWhenInUseOperation: Operation {
  
  let locationManager = CLLocationManager()
  var error: OperationError?
  
  override init() {
    print("RequestLocationWhenInUse Operation init")
  }
  
  
  override func main() {
    if isCancelled { return }
    
    // check for service before this?  See if the phone is in airplane mode or has no service
    let enabled = CLLocationManager.locationServicesEnabled()
    let status = CLLocationManager.authorizationStatus()
    
    switch (enabled, status) {
    case (true, .authorizedWhenInUse):
      break
    case (true, .authorizedAlways):
      break
    default:
      error = .failed("Error")
    }
    
//    if let error = error {
//      completion(.failed)
//    } else {
//      completion(.satisfied)
//    }
  }
  
}

// private class

enum OperationError: Error {
  case failed(String)
}
