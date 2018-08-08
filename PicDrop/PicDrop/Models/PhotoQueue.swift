//
//  PhotoQueue.swift
//  PicDrop
//
//  Created by Nicholas Rizzo on 8/1/18.
//  Copyright © 2018 Nicholas Rizzo. All rights reserved.
//

import UIKit

struct PhotoQueue {
  
  private var queue = [Photo]()
  
  var count: Int {
    return queue.count
  }
  
  func getNextPost() -> Photo? {
    return queue.first
  }
  
  mutating func append(_ photo: Photo) {
    queue.append(photo)
  }
  
//  mutating func popFirstPost() -> Post? {
//    guard queue.count > 0 else {
//      return nil
//    }
//    return queue.removeFirst()
//
//    // can't call queue.popFirst() to optionally return Post for some reason...
//  }
  
  mutating func removePhoto(with postID: String) {
    let indexOfPostID = queue.index { $0.id == postID }
    if let index = indexOfPostID {
      queue.remove(at: index)
    }
  }
}
