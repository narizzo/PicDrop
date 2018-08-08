//
//  Cache.swift
//  PicDrop
//
//  Created by Nicholas Rizzo on 8/6/18.
//  Copyright © 2018 Nicholas Rizzo. All rights reserved.
//

import Foundation
import CoreData

class Cache: NSObject {
  
  var coreDataStack: CoreDataStack!
  let previouslyVotedPosts = PreviouslyVotedPosts()
  
  private lazy var nearbyPosts: NearbyPosts = {
    let np = NearbyPosts(entity: NearbyPosts.entity(), insertInto: coreDataStack.managedContext)
    coreDataStack.managedContext.insert(np)
    return np
  }()
  
  init(_ coreDataStack: CoreDataStack) {
    super.init()
    self.coreDataStack = coreDataStack
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
      let post = Post(entity: Post.entity(), insertInto: coreDataStack.managedContext)
      post.setValue(key, forKey: "uuid")
      nearbyPosts.addToPosts(post)
    }
    notifyCacheDataHasChanged()
  }
  
  private func notifyCacheDataHasChanged() {
    NotificationCenter.default.post(name: NSNotification.Name(Constants.NotificationName.nearbyPostsName.rawValue), object: nil, userInfo: ["nearbyPosts": nearbyPosts])
  }
  
  // Clear old geoCircle query results
  private func clearNearbyPostsCache() {
    guard let posts = nearbyPosts.posts else {
      return
    }
    nearbyPosts.removeFromPosts(posts)
  }

}

//extension Cache: NSFetchedResultsControllerDelegate {
//
//  func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
//    // fire off observable
//    print("controllerDidChangeContent")
//    NotificationCenter.default.post(name: NSNotification.Name(Constants.NotificationName.nearbyPostsName.rawValue), object: nil, userInfo: ["nearbyPosts": nearbyPosts])
//  }
//
//}

// ensure that nearbyPosts exists - if not - make one
//  private lazy var nearbyPosts: NearbyPosts = {
//    var np: NearbyPosts
//    if let fetchedPosts = fetchedResultsController.fetchedObjects?.first {
//      np = fetchedPosts
//    } else {
//      np = NearbyPosts(entity: NearbyPosts.entity(), insertInto: coreDataStack.managedContext)
//    }
//    return np
//  }()

//  private var nearbyPosts: NearbyPosts {
//    get {
//      if let nearbyPosts = nearbyPosts {
//        return nearbyPosts
//      } else {
//        let nearbyPosts = NearbyPosts(entity: NearbyPosts.entity(), insertInto: coreDataStack.managedContext)
//        coreDataStack.managedContext.insert(nearbyPosts)
//        return nearbyPosts
//      }
//    }
//  }

//  lazy var fetchedResultsController: NSFetchedResultsController<NearbyPosts> = {
//    let fetchRequest: NSFetchRequest<NearbyPosts> = NearbyPosts.fetchRequest()
//    fetchRequest.sortDescriptors = []
//
//    let fetchedResultsController = NSFetchedResultsController(
//      fetchRequest: fetchRequest,
//      managedObjectContext: coreDataStack.managedContext,
//      sectionNameKeyPath: nil,
//      cacheName: nil)
//    fetchedResultsController.delegate = self
//    return fetchedResultsController
//  }()
