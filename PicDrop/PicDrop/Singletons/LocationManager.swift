//
//  LocationManager.swift
//  PicDrop
//
//  Created by Nicholas Rizzo on 7/17/18.
//  Copyright © 2018 Nicholas Rizzo. All rights reserved.
//

import Foundation
import CoreLocation


public final class LocationManager {
  static let shared = LocationManager()
  
  private init() {}
  
  var locationManager: CLLocationManager = {
    let manager = CLLocationManager()
    manager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
    manager.activityType = .other
    //manager.allowDeferredLocationUpdates(untilTraveled: CLLocationDistance, timeout: TimeInterval)
    return manager
  }()
  
  // use observable instead of method calls to update accuracy?
  public func setAccuracyForFindingPhotos() {
    locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
  }
  
  public func setAccuracyForPostingPhotos() {
    locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
  }
  
//  public func resumeLocationUpdates() {
//    locationManager.startUpdatingLocation()
//  }
//
//  public func pauseLocationUpdates() {
//    locationManager.stopUpdatingLocation()
//  }
//
//  public func requestWhenInUseAuthorization() {
//    locationManager.requestWhenInUseAuthorization()
//  }

}
