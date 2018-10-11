//
//  DownloadNearbyUUIds.swift
//  PicDrop
//
//  Created by Nicholas Rizzo on 10/5/18.
//  Copyright © 2018 Nicholas Rizzo. All rights reserved.
//

import Foundation
import CoreLocation
import ProcedureKit
import ProcedureKitLocation

// make Mutually Exclusive
class NearbyUUIdsDownloadProcedure: GroupProcedure {
  
  init(cache: Cache, networkManager: NetworkManager) {

    // conditions:
    // network connectivity
    // logged in to firebase
    
    let getLocation = UserLocationProcedure()
    let locationQuery = LocationQueryProcedure(cache: cache)
    locationQuery.injectResult(from: getLocation)
    
    super.init(operations: [getLocation, locationQuery])
    
    name = "Location Query and UUID Download"
    
    addCondition(MutuallyExclusive<NearbyUUIdsDownloadProcedure>())
  }
  
}
