//
//  PreviouslyVotedPosts.swift
//  PicDrop
//
//  Created by Nicholas Rizzo on 8/7/18.
//  Copyright © 2018 Nicholas Rizzo. All rights reserved.
//

import UIKit

class PreviouslyVotedPosts: NSObject, Codable {
  
  private var previouslyVotedPosts = Set<UUID>()

  override init() {
    super.init()
  }
  
  
  private func documentsDirectory() -> URL {
    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
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
  
  func addToVotedPosts(_ postUUID: UUID) {
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

