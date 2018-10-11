//
//  LocationOperation.swift
//  PicDrop
//
//  Created by Nicholas Rizzo on 9/10/18.
//  Copyright © 2018 Nicholas Rizzo. All rights reserved.
//

/* Abstract
 An operation that asynchronously gets the phone's current location and passes that location to dependent operations
 */

import ProcedureKit
import ProcedureKitLocation

class GetLocationOperation: Procedure {
  override init() {
    super.init()
    name = "Location Operation"
    addCondition(AuthorizedFor(Capability.Location(.whenInUse)))
  }
  
  override func execute() {
    let getLocation = UserLocationProcedure()
    
    finish()
  }
}

//import Foundation
//import CoreLocation
//
//class GetLocationOperation: Operation, LocationDataProvider {
//
//  // MARK: Properties
//  private var locationManager: CLLocationManager
//  var location: CLLocation?
//  //var error: Error
//
//  init(locationManager: CLLocationManager) {
//    self.locationManager = locationManager
//    super.init()
//  }
//
//  // MARK: Operation Body
//  override func main() {
//    if isCancelled {
//      cancel()
//    }
//
//    if let loc = locationManager.location {
//      self.location = loc
//    } else {
//      // set error variable
//    }
//  }
//
//}
