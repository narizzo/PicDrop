//
//  Cache.swift
//  PicDrop
//
//  Created by Nicholas Rizzo on 8/6/18.
//  Copyright © 2018 Nicholas Rizzo. All rights reserved.
//

import UIKit

class Cache: NSObject {
  
  // MARK: - Internal
  private let previouslyVotedPosts = PreviouslyVotedPosts()
  
  private var nearbyPosts = [Post]() // change to [UUID](?)
  @objc private(set) dynamic var nearbyKeys = [UUID]()
  
  func process(_ imageData: Data, for postID: String) {
    guard let image = UIImage(data: imageData),
      let uuid = UUID(uuidString: postID) else {
        return
    }
    
    //let photo = Photo(uuid: uuid, image: image)
    
    //NotificationCenter.default.post(name: NSNotification.Name(Constants.NotificationName.imageDataHasDownloaded.rawValue), object: nil, userInfo: [Constants.UserInfo.Key.photo: photo])
  }
  
  func processKeys(_ keys: [String]) {
    guard let newKeys = previouslyVotedPosts.filterRepeat(keys) else {
      return
    }
    update(nearbyPostKeys: newKeys)
  }
  
  private func update(nearbyPostKeys newKeys: [UUID]) {
    guard newKeys.count > 0 else { return }  // if there aren't any new keys then the app should continue working with the old keys
    nearbyKeys = newKeys
  }
}
