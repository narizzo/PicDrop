//
//  PreviouslyVotedPosts.swift
//  PicDrop
//
//  Created by Nicholas Rizzo on 8/7/18.
//  Copyright © 2018 Nicholas Rizzo. All rights reserved.
//

import UIKit

class PreviouslyVotedPosts: NSObject, Codable {
  
  private var votedPosts = [UUID]()

  override init() {
    super.init()
    loadData()
  }
  
  
  private func documentsDirectory() -> URL {
    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    return paths[0]
  }
  
  private func dataFilePath() -> URL {
    return documentsDirectory().appendingPathComponent("previouslyVotedPosts.plist")
  }
  
  private func loadData() {
    let path = dataFilePath()
    if let data = try? Data(contentsOf: path) {
      let decoder = PropertyListDecoder()
      do {
        votedPosts = try decoder.decode([UUID].self, from: data)
      } catch let error as NSError {
        print("\(error): \(error.userInfo)")
      }
    }
  }
  
  private func saveData() {
    let encoder = PropertyListEncoder()
    do {
      let data = try encoder.encode(votedPosts)
      try data.write(to: dataFilePath(), options: Data.WritingOptions.atomic)
    } catch let error as NSError {
      print("\(error): \(error.userInfo)")
    }
  }
  
  func addToVotedPosts(_ postUUID: UUID) {
    votedPosts.append(postUUID)
  }
  
  func filterRepeat(_ postUIDStrings: [String]) -> [UUID]? {
    return filterRepeat(postUIDStrings.compactMap({ (postString) -> UUID? in
      UUID(uuidString: postString)
    }))
  }
  
  func filterRepeat(_ postUIDs: [UUID]) -> [UUID]? {
    return postUIDs.filter({ (postUID) -> Bool in
      !votedPosts.contains(postUID)
    })
  }
}

