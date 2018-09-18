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

import Foundation
import CoreLocation

class LocationOperation: AsynchronousOperation, CLLocationManagerDelegate, LocationDataProvider {
  
  // MARK: Properties
  private var manager: CLLocationManager?
  var location: CLLocation?
  
  // MARK: Operation Body
  override func main() {
    DispatchQueue.main.async {
      self.manager = CLLocationManager()
      self.manager?.desiredAccuracy = kCLLocationAccuracyHundredMeters
      //self.manager?.desiredAccuracy = kCLLocationAccuracyNearestTenMeters // didUpdateLocations accuracy test never succeeds with this accuracy
      self.manager?.delegate = self
      self.manager?.startUpdatingLocation()
    }
  }
  
  override func cancel() {
    DispatchQueue.main.async {
      self.manager?.stopUpdatingLocation()
      super.cancel()
    }
  }
  
  // MARK: CLLocationManagerDelegate
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    if isCancelled {
      manager.stopUpdatingLocation()
      finish()
    }
    guard let location = locations.last,
      location.horizontalAccuracy <= manager.desiredAccuracy,
      location.verticalAccuracy <= manager.desiredAccuracy else {
        return
    }
    manager.stopUpdatingLocation()
    self.location = location
    finish()
  }
  
  func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    manager.stopUpdatingLocation()
    print("Failure to find location") // handle this eventually
    finish()
  }
}
