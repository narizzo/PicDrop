//
//  PostQueue.swift
//  PicDrop
//
//  Created by Nicholas Rizzo on 7/31/18.
//  Copyright © 2018 Nicholas Rizzo. All rights reserved.
//

import UIKit

protocol PostQueueDelegate: class {
  func postQueue(_ postQueue: PostQueue, needsMorePosts: Bool)
}

class PostQueue {
  
  // MARK: - Injection
  private weak var delegate: PostQueueDelegate?
  
  // MARK: - Instance Variables
  private var queue = [Post]() {
    didSet {
      if queue.count == 0 {
        delegate?.postQueue(self, needsMorePosts: true)
      }
    }
  }
  
  // MARK: - Init
  init(delegate: PostQueueDelegate) {
    self.delegate = delegate
  }
  
  // MARK: - Methods
  func peekNextPost() -> Post? {
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
  }
  
  func append(_ posts: [Post]) {
    queue.append(contentsOf: posts)
  }
  
  func replaceQueue(with posts: [Post]) {
    queue = posts
  }
  
  
}
