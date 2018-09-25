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

struct PreviouslyVotedPosts: Codable {
  
  private var previouslyVotedPosts = Set<UUID>()
  
  private func documentsDirectory() -> URL {
    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask) // change to applicationSupportDirectory
    return paths[0]
  }
  
  private func dataFilePath() -> URL {
    return documentsDirectory().appendingPathComponent("previouslyVotedPosts.plist") // use logged in user's id + "previouslyVotedPosts.plist"?
    // allow user to delete local storage of keys.
  }
  
  private mutating func loadData() {
    let path = dataFilePath()
    if let data = try? Data(contentsOf: path) {
      let decoder = PropertyListDecoder()
      do {
        previouslyVotedPosts = try decoder.decode(Set<UUID>.self, from: data)
      } catch let error as NSError {
        print("\(error): \(error.userInfo)")
      }
    }
  }
  
  private func saveData() {
    let encoder = PropertyListEncoder()
    do {
      let data = try encoder.encode(previouslyVotedPosts)
      try data.write(to: dataFilePath(), options: Data.WritingOptions.atomic)
    } catch let error as NSError {
      print("\(error): \(error.userInfo)")
    }
  }
  
  mutating func addToVotedPosts(_ postUUID: UUID) {
    previouslyVotedPosts.insert(postUUID)
  }
  
  func filterRepeat(_ postUIDStrings: [String]) -> [UUID]? {
    return filterRepeat(postUIDStrings.compactMap({ (postString) -> UUID? in
      UUID(uuidString: postString)
    }))
  }
  
  func filterRepeat(_ postUIDs: [UUID]) -> [UUID]? {
    return postUIDs.filter({ (postUID) -> Bool in
      !previouslyVotedPosts.contains(postUID)
    })
  }
}

