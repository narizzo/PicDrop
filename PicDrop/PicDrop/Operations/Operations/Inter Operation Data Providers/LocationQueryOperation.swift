//
//  LocationQueryOperation.swift
//  PicDrop
//
//  Created by Nicholas Rizzo on 9/12/18.
//  Copyright © 2018 Nicholas Rizzo. All rights reserved.
//

/* Abstract:
   Query Firebase for posts near a passed in CLLocation
 */

import Foundation
import CoreLocation
import GeoFire

class LocationQueryOperation: AsynchronousOperation {
  
  private let geoFireRef = GeoFire(firebaseRef: Constants.Firebase.Database.postLocationsRef)
  private var location: CLLocation?
  private let handler: ([String]) -> Void
  
  init(handler: @escaping ([String]) -> Void) {
    self.handler = handler
    super.init()
  }
  
  override func main() {
    if let dependencyLocationProvider = dependencies
      .filter({ $0 is LocationDataProvider })
      .first as? LocationDataProvider,
      self.location == .none {
      self.location = dependencyLocationProvider.location
    }
    
    guard let location = location else {
      return
    }
    
    var nearbyPostKeysCollector = [String]()
    let circleQuery = geoFireRef.query(at: location, withRadius: location.horizontalAccuracy)
    let _ = circleQuery.observe(.keyEntered) { (key, location) in
      nearbyPostKeysCollector.append(key)
    }
    
    circleQuery.observeReady { [weak self] in
      self?.handler(nearbyPostKeysCollector)
      circleQuery.removeAllObservers()
      self?.finish()
    }
  }
  
}

