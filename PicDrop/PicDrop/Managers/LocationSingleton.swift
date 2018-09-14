//
//  LocationSingleton.swift
//  PicDrop
//
//  Created by Nicholas Rizzo on 7/17/18.
//  Copyright © 2018 Nicholas Rizzo. All rights reserved.
//

import Foundation
import CoreLocation

public final class LocationSingleton {
  
  static let shared = LocationSingleton()
  
  lazy var locationManager: CLLocationManager = {
    let clm = CLLocationManager()
    clm.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
    clm.distanceFilter = 30
    return clm
  }()
  
  // MARK: - Init
  private init() {}
  
}
