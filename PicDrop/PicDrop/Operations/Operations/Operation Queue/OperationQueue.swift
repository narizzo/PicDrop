////
////  PhotoOperations.swift
////  PicDrop
////
////  Created by Nicholas Rizzo on 8/14/18.
////  Copyright © 2018 Nicholas Rizzo. All rights reserved.
////
//
//import UIKit
//import CoreLocation
//import GeoFire
//
//enum OperationState {
//  case new, downloaded, failed, inProgress, cancelled
//}
//
//protocol NetworkOperationsDelegate: class {
//  func networkOperations(_ networkOperations: OperationQueue, didFinishDownloadingKeys keys: [String])
//}
//
//class OperationQueue {
//
//  // MARK: - Injection
//  weak var delegate: NetworkOperationsDelegate?
//
//  // MARK: - Instance Variables
//  var cache: Cache
//
////  lazy var completionHandler: () -> Void = { [weak cache] in
////    cache?.process()
////  }
//
//  // Location Query
//  lazy var locationQueryOperation: LocationQueryOperation = {
//    let lqo = LocationQueryOperation(cache: cache, location: LocationSingleton.shared.locationManager.location!)
//    lqo.name = "Location Query Operation"
//
////    lqo.completionBlock = { [unowned lqo] in
////      self.delegate?.networkOperations(self, didFinishDownloadingKeys: lqo.nearbyPostKeysCollector)
////    }
//    return lqo
//  }()
//
//  // Download
//  lazy var downloadsInProgress = [IndexPath: Operation]()
//  lazy var downloadQueue: OperationQueue = {
//    var queue = OperationQueue()
//    queue.name = "Download Queue"
//    return queue
//  }()
//
//  // Upload
//  lazy var uploadsInProgress = [IndexPath: Operation]()
//  lazy var uploadQueue: OperationQueue = {
//    var queue = OperationQueue()
//    queue.name = "Upload Queue"
//    return queue
//  }()
//
//  init(cache: Cache) {
//    self.cache = cache
//  }
//
//  // MARK: - Methods
//  func queryLocationForPosts() {
//
////    BlockOperation {
////      let geoFireRef = GeoFire(firebaseRef: Constants.Firebase.Database.postLocationsRef)
////      var nearbyPostKeysCollector = [String]()
////      let circleQuery = geoFireRef.query(at: location, withRadius: 0.1)
////
////      let _ = circleQuery.observe(.keyEntered) { (key, location) in
////        nearbyPostKeysCollector.append(key)
////      }
////
////      circleQuery.observeReady {
////        circleQuery.removeAllObservers()
////        print(nearbyPostKeysCollector)
////      }
////    }.start()
//
//
//    //cancelLocationQuery()
////    locationQueryOperation.location = location
////
////    DispatchQueue.global().async {
////      self.locationQueryOperation.start()
////    }
//  }
//
//  func cancelLocationQuery() {
//    locationQueryOperation.cancel()
//  }
//
//}
