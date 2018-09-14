//
//  CacheService.swift
//  PicDrop
//
//  Created by Nicholas Rizzo on 8/24/18.
//  Copyright © 2018 Nicholas Rizzo. All rights reserved.
//

import Foundation

public protocol CacheService {
  
  func process(_ nearbyPostKeys: [String])
  
  func process(_ imageData: Data, for postID: String)
  
  func notifyCacheDataHasChanged()
  
}

