//
//  PostsVC+CacheDelegate.swift
//  PicDrop
//
//  Created by Nicholas Rizzo on 9/20/18.
//  Copyright © 2018 Nicholas Rizzo. All rights reserved.
//

import Foundation

extension PostsViewController: CacheDelegate {
  
  func cacheDidFailToUpdateWithNewUUIds(_ cache: Cache) {
    networkManager.fetchNearbyPostUUIDs()
  }
  
  func cache(_ cache: Cache, didUpdateUUIDs uuids: [UUID]) {
    uuidQueue.replaceElements(with: uuids)
  }
  
  func cache(_ cache: Cache, didUpdatePosts posts: [PartialPost]) {
    postQueue.replaceElements(with: posts)
  }
}
