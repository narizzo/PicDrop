//
//  PhotoQueue.swift
//  PicDrop
//
//  Created by Nicholas Rizzo on 8/1/18.
//  Copyright © 2018 Nicholas Rizzo. All rights reserved.
//

import UIKit

protocol PhotoQueueDelegate: class {
  func photoQueue(_ photoQueue: PostQueue, didReceivePhoto: Bool)
}

class PostQueue {
  
  // MARK: - Injection
  weak var delegate: PhotoQueueDelegate?
  
  // MARK: - Instance Variables
  private var queue = [Photo]()
  
  var count: Int {
    return queue.count
  }
  
  // MARK: - Init
  init(delegate: PhotoQueueDelegate) {
    self.delegate = delegate
  }
  
  // MARK: - Methods
  func peek() -> Photo? {
    return queue.first
  }
  
  func pop() -> Photo? {
    if queue.count > 0 {
      return queue.removeFirst()
    }
    return nil
  }
  
  func append(_ photo: Photo) {
    queue.append(photo)
    delegate?.photoQueue(self, didReceivePhoto: true)
  }
  
//  mutating func popFirstPost() -> Post? {
//    guard queue.count > 0 else {
//      return nil
//    }
//    return queue.removeFirst()
//
//    // can't call queue.popFirst() to optionally return Post for some reason...
//  }
  
  func remove(_ photo: Photo) {
    let indexOfPostID = queue.index { $0.uuid == photo.uuid }
    if let index = indexOfPostID {
      queue.remove(at: index)
    }
  }
  
}
