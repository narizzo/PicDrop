//
//  LocationManager.swift
//  PicDrop
//
//  Created by Nicholas Rizzo on 7/17/18.
//  Copyright © 2018 Nicholas Rizzo. All rights reserved.
//

import Foundation
import CoreLocation

//public final class LocationManager: NSObject, CLLocationManagerDelegate {
//  public var locationManager: CLLocationManager = {
//    let manager = CLLocationManager()
//    manager.desiredAccuracy = kCLLocationAccuracyBest
//    return manager
//  }()
//
//}

public var locationManager: CLLocationManager = {
    let manager = CLLocationManager()
    manager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
    //kCLLocationAccuracyBest
    return manager
  }()
