//
//  Cache.swift
//  PicDrop
//
//  Created by Nicholas Rizzo on 8/6/18.
//  Copyright © 2018 Nicholas Rizzo. All rights reserved.
//

import UIKit
import CoreData

class Cache: CacheService { // NSObject ??
  
  // MARK: - Internal
  let previouslyVotedPosts = PreviouslyVotedPosts()
  
  private var nearbyPosts = [Post]() // change to [UUID](?)
  
  func process(_ imageData: Data, for postID: String) {
    guard let image = UIImage(data: imageData),
      let uuid = UUID(uuidString: postID) else {
        return
    }
    
    let photo = Photo(uuid: uuid, image: image)
    
    NotificationCenter.default.post(name: NSNotification.Name(Constants.NotificationName.imageDataHasDownloaded.rawValue), object: nil, userInfo: [Constants.UserInfo.Key.photo: photo])
  }
  
  func process(_ nearbyPostKeys: [String]) {
    /*  check for newKeys,
        if there are new keys: clear old keys, add new keys, and send out notification
        if none, return
    */
    guard let newKeys = previouslyVotedPosts.filterRepeat(nearbyPostKeys) else {
      return
    }
    update(nearbyPostKeys: newKeys)
  }
  
  private func update(nearbyPostKeys newKeys: [UUID]) {
    clearNearbyPostsCache()
    
    newKeys.forEach { (key) in
      print(key)
      //nearbyPosts.addToPosts(post)
    }
    
    notifyCacheDataHasChanged()
  }
  
  func notifyCacheDataHasChanged() {
    NotificationCenter.default.post(name: NSNotification.Name(Constants.NotificationName.nearbyPosts.rawValue), object: nil, userInfo: ["nearbyPosts": nearbyPosts])
  }
  
  // Clear old geoCircle query results
  private func clearNearbyPostsCache() {
    nearbyPosts.removeAll()
  }

}
