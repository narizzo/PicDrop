//
//  NetworkRequest.swift
//  PicDrop
//
//  Created by Nicholas Rizzo on 8/16/18.
//  Copyright © 2018 Nicholas Rizzo. All rights reserved.
//

import UIKit
import CoreLocation

public protocol DatabaseService {
  
  // these should be in this protocol so we can swap them out at test time
  var cacheService: CacheService {get set}
  var locationSingleton: LocationSingleton {get set}

  func fetchData(at location: CLLocation,
                 completion: @escaping (Error?, Data?) -> Void)
  
  func fetchImageData(for postID: String,
                  completion: @escaping (String?, Data?) -> Void)
  
  func upload(data: Data)
  
  
}
