//
//  PhotoQueue.swift
//  PicDrop
//
//  Created by Nicholas Rizzo on 7/31/18.
//  Copyright © 2018 Nicholas Rizzo. All rights reserved.
//

import Foundation

struct PostQueue {

  private var queue = [String]()
//  {
//    didSet {
//      NotificationCenter.default.post(name: NSNotification.Name(Constants.NotificationName.postQueueName.rawValue), object: nil, userInfo: ["posts": queue])
//    }
//  }

  func peekNextPost() -> String? {
    return queue.first
  }

  mutating func addPostToQueue(_ post: String) {
    queue.append(post)
  }

  mutating func popFirstPost() -> String? {
    guard queue.count > 0 else {
      return nil
    }
    return queue.removeFirst()

    // can't call queue.popFirst() to optionally return Post for some reason...
  }
  
  mutating func append(_ posts: [String]) {
    let newPosts = filterOutPreviouslySeen(posts)
    queue.append(contentsOf: newPosts)
  }
  
  // Doesn't actually do anything yet
  mutating func filterOutPreviouslySeen(_ posts: [String]) -> [String] {
    return posts
  }
  
}
