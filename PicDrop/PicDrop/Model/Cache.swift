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
  func cache(_ cache: Cache, didUpdatePosts posts: [PartialPost])
  func cacheDidFailToUpdateWithNewUUIds(_ cache: Cache)
}

class Cache {
  
  // MARK: - Injection
  weak var delegate: CacheDelegate?
  
  // MARK: - Properties
  private var previouslyVotedPosts = PreviouslyVotedPosts()
  private var newUUIDs = [UUID]() {
    didSet {
      delegate?.cache(self, didUpdateUUIDs: newUUIDs)
    }
  }
  private var newPosts = [PartialPost]() {
    didSet {
      delegate?.cache(self, didUpdatePosts: newPosts)
    }
  }
  
  // MARK: - Methods
  func processPartialPost(_ partialPost: PartialPost) {
    newPosts.append(partialPost)
  }
  
  func processKeys(_ keys: [String]) {
    // if there aren't any new keys then the app should continue working with the old keys
    guard let newKeys = previouslyVotedPosts.filterRepeat(keys),
      newKeys.count > 0 else {
      delegate?.cacheDidFailToUpdateWithNewUUIds(self)
      return
    }
    
    newUUIDs = newKeys
    print(newUUIDs.forEach { uuid in print("\(uuid)")})
  }
  
  // the user shouldn't see his/her own posts, therefore we add the uuid of their post locally, so that we can filter it out of query results without having to download the updated list of previouslyVotedPosts on the server for that user.
  func processPostCreatedByUser(_ post: Post) {
    previouslyVotedPosts.add(postUUID: post.uuid)
  }
  
}
