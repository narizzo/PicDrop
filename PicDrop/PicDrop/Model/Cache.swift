//
//  Cache.swift
//  PicDrop
//
//  Created by Nicholas Rizzo on 8/6/18.
//  Copyright © 2018 Nicholas Rizzo. All rights reserved.
//

import UIKit

protocol CacheDelegate: class {
  func cache(_ cache: Cache, didUpdateUUIDs uuids: [UUID])
  func cache(_ cache: Cache, didUpdatePosts posts: [Post])
}

class Cache {
  
  // MARK: - Injection
  weak var delegate: CacheDelegate?
  
  // MARK: - Properties
  private let previouslyVotedPosts = PreviouslyVotedPosts()
  private var newUUIDs = [UUID]() {
    didSet {
      delegate?.cache(self, didUpdateUUIDs: newUUIDs)
    }
  }
  private var newPosts = [Post]() {
    didSet {
      delegate?.cache(self, didUpdatePosts: newPosts)
    }
  }
  
//  @objc private(set) dynamic var newUUIDs = [UUID]()
//  @objc private(set) dynamic var newPosts = [Post]()
  
  // MARK: - Methods
  func process(_ imageData: Data, for uuid: UUID) {
    guard let image = UIImage(data: imageData) else {
      return
    }
    
    //let photo = Photo(uuid: uuid, image: image)
    
    //NotificationCenter.default.post(name: NSNotification.Name(Constants.NotificationName.imageDataHasDownloaded.rawValue), object: nil, userInfo: [Constants.UserInfo.Key.photo: photo])
  }
  
  func process(new post: Post) {
    
  }
  
  func processKeys(_ keys: [String]) {
    guard let newKeys = previouslyVotedPosts.filterRepeat(keys) else {
      return
    }
    update(nearbyPostKeys: newKeys)
  }
  
  private func update(nearbyPostKeys newKeys: [UUID]) {
    guard newKeys.count > 0 else { return }  // if there aren't any new keys then the app should continue working with the old keys
    newUUIDs = newKeys
  }
}
