//
//  LocationQueryProcedure.swift
//  PicDrop
//
//  Created by Nicholas Rizzo on 10/9/18.
//  Copyright © 2018 Nicholas Rizzo. All rights reserved.
//

import Foundation
import CoreLocation
import GeoFire
import ProcedureKit

class LocationQueryProcedure: Procedure, InputProcedure {
  var input: Pending<CLLocation> = .pending
  
  private let geoFireRef = GeoFire(firebaseRef: Constants.Firebase.Database.postLocationsRef)
  private let cache: Cache
  
  init(cache: Cache) {
    self.cache = cache
    super.init()
    
    //addDependency(LocalDataLoadProcedure(cache: cache))
    addCondition(MutuallyExclusive<LocationQueryProcedure>())
  }
  
  override func execute() {
    guard let location = input.value else {
      finish()
      return
    }
    
    var nearbyPostKeysCollector = [String]()
    let circleQuery = geoFireRef.query(at: location, withRadius: location.horizontalAccuracy)
    let _ = circleQuery.observe(.keyEntered) { (key, location) in
      nearbyPostKeysCollector.append(key)
    }
    
    circleQuery.observeReady { [weak self] in
      self?.cache.processKeys(nearbyPostKeysCollector)
      circleQuery.removeAllObservers()
      self?.finish()
    }
    finish()
  }
  
}

//class LocalDataLoadProcedure: Procedure {
//  
//  private let cache: Cache
//  
//  init(cache: Cache) {
//    self.cache = cache
//    super.init()
//  }
//  
//  override func execute() {
//    
//  }
//  
//}
