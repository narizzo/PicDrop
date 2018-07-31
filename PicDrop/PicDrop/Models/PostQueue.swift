//
//  PhotoQueue.swift
//  PicDrop
//
//  Created by Nicholas Rizzo on 7/31/18.
//  Copyright © 2018 Nicholas Rizzo. All rights reserved.
//

import UIKit

class PostQueue {
  
  private var queue = [Post]()
  
  func getNextPost() -> Post? {
    return queue.first
  }
  
  func addPostToQueue(_ post: Post) {
    queue.append(post)
  }
  
  func popFirstPost() -> Post? {
    guard queue.count > 0 else {
      return nil
    }
    return queue.removeFirst()
    
    // can't call queue.popFirst() to optionally return Post for some reason...
  }
}
