//
//  QueryLocationOperation.swift
//  PicDrop
//
//  Created by Nicholas Rizzo on 9/10/18.
//  Copyright © 2018 Nicholas Rizzo. All rights reserved.
//

import Foundation
import CoreLocation

class LocationOperation: Operation, CLLocationManagerDelegate {
  
  // MARK: Properties
  private var manager: CLLocationManager?
  //private let networkManager: NetworkManager
  private let handler: (CLLocation) -> Void
  // MARK: Initialization
  //init(networkManager: NetworkManager, locationHandler: @escaping (CLLocation) -> Void) {
  init(locationHandler: @escaping (CLLocation) -> Void) {
    self.handler = locationHandler
    super.init()
  }
  
  func execute() {
    DispatchQueue.main.async {
      let manager = CLLocationManager()
      manager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
      manager.delegate = self
      manager.startUpdatingLocation()
      self.manager = manager
    }
  }
  
  override func cancel() {
    DispatchQueue.main.async {
      self.stopLocationUpdates()
      super.cancel()
    }
  }
  
  private func stopLocationUpdates() {
    manager?.stopUpdatingLocation()
    manager = nil
  }
  
  // MARK: CLLocationManagerDelegate
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    guard let location = locations.last,
      location.horizontalAccuracy <= manager.desiredAccuracy else {
      return
    }
    stopLocationUpdates()
    handler(location)
  }
  
  func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    stopLocationUpdates()
    print("Failure to find location")
    self.cancel()
  }
}


