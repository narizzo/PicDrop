//
//  LocationManager.swift
//  PicDrop
//
//  Created by Nicholas Rizzo on 7/17/18.
//  Copyright © 2018 Nicholas Rizzo. All rights reserved.
//

import Foundation
import CoreLocation


public final class LocationManager: CLLocationManager, CLLocationManagerDelegate {

  // MARK: - Accuracy
  public func setAccuracyForFindingPhotos() {
    desiredAccuracy = kCLLocationAccuracyNearestTenMeters
  }

  public func setAccuracyForPostingPhotos() {
    desiredAccuracy = kCLLocationAccuracyBest
  }

}
