//
//  PreviouslyVotedPosts.swift
//  PicDrop
//
//  Created by Nicholas Rizzo on 8/7/18.
//  Copyright © 2018 Nicholas Rizzo. All rights reserved.
//

import UIKit

/* Abstract: -The interface for storing and retrieving the user's vote history.
 -The vote history is a set of UUID that the user has voted on.
 -This data is loaded and saved locally and is synchronized with the user's vote history data on Firebase
 -Previously-voted-on nearby post uuids, passed in from NetworkManager are filtered out by this struct and handed off to the
 PostsViewController via KVO observable */

class PreviouslyVotedPosts: Codable {
  
  private var previouslyVotedPosts = Set<UUID>()
  
  private func documentsDirectory() -> URL {
    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask) // change to applicationSupportDirectory
    return paths[0]
  }
  
  private func dataFilePath() -> URL {
    return documentsDirectory().appendingPathComponent("previouslyVotedPosts.plist") // use logged in user's id + "previouslyVotedPosts.plist"?
    // allow user to delete local storage of keys.
  }

  private func loadData() {
    let path = dataFilePath()
    if let data = try? Data(contentsOf: path) {
      let decoder = PropertyListDecoder()
      do {
        self.previouslyVotedPosts = try decoder.decode(Set<UUID>.self, from: data)
      } catch let error as NSError {
        print("\(error): \(error.userInfo)")
      }
    }
  }
  
  // async
//  private func loadData(completion: @escaping () -> Void) {
//    let path = dataFilePath()
//    DispatchQueue.global(qos: .userInitiated).async {
//      if let data = try? Data(contentsOf: path) {
//        let decoder = PropertyListDecoder()
//        do {
//          self.previouslyVotedPosts = try decoder.decode(Set<UUID>.self, from: data)
//        } catch let error as NSError {
//          print("\(error): \(error.userInfo)")
//        }
//      }
//    }
//  }
  
  private func saveData() {
    let encoder = PropertyListEncoder()
    do {
      let data = try encoder.encode(previouslyVotedPosts)
      try data.write(to: dataFilePath(), options: Data.WritingOptions.atomic)
    } catch let error as NSError {
      print("\(error): \(error.userInfo)")
    }
  }
  
  func add(postUUID: UUID) {
    previouslyVotedPosts.insert(postUUID)
    // save every time or only save on app close?
  }
  
  // Sync - Originals
  func filterRepeat(_ postUUIDStrings: [String]) -> [UUID]? {
    return filterRepeat(postUUIDStrings.compactMap({ (postString) -> UUID? in
      UUID(uuidString: postString)
    }))
  }
  
  func filterRepeat(_ postUUIDs: [UUID]) -> [UUID]? {
    return postUUIDs.filter({ (postUID) -> Bool in
      !previouslyVotedPosts.contains(postUID)
    })
  }
  
  // should be async because theoretically we could be filtering thousands of keys.  If each took half a ms that would be a 500 ms delay for 1000 keys
  // Async Versions
  //  func filterRepeat(_ postUUIDStrings: [String], completion: @escaping ([UUID]?) -> ()) {
  //    DispatchQueue.global().async {
  //      let newUUIds = self.filterRepeat(postUUIDStrings.compactMap({ (postString) -> UUID? in
  //        UUID(uuidString: postString)
  //      }))
  //    completion(newUUIds)
  //    }
  //  }
  
  // Async - necessary?
  //  func filterRepeat(_ postUUIDs: [UUID], completion: @escaping ([UUID]?) -> Void) {
  //    DispatchQueue.global().async {
  //      completion(postUUIDs.filter({ (postUID) -> Bool in
  //        !self.previouslyVotedPosts.contains(postUID)
  //      }))
  //    }
  //  }

}

