//
//  PostQueue.swift
//  PicDrop
//
//  Created by Nicholas Rizzo on 7/31/18.
//  Copyright © 2018 Nicholas Rizzo. All rights reserved.
//

import UIKit

protocol KeyQueueDelegate: class {
  func keyQueue(_ keyQueue: KeyQueue, needsMoreKeys: Bool)
}

class KeyQueue {
  
  // MARK: - Injection
  private weak var delegate: KeyQueueDelegate?
  
  // MARK: - Instance Variables
  private var queue = [UUID]() {
    didSet {
      if queue.count == 0 {
        delegate?.keyQueue(self, needsMoreKeys: true)
      }
    }
  }
  
  // MARK: - Init
  init(delegate: KeyQueueDelegate) {
    self.delegate = delegate
  }
  
  // MARK: - Methods
  func peekNextKey() -> UUID? {
    return queue.first
  }
  
  func addKeyToQueue(_ key: UUID) {
    queue.append(key)
  }
  
  func popFirstKey() -> UUID? {
    guard queue.count > 0 else {
      return nil
    }
    return queue.removeFirst()
  }
  
  func append(_ keys: [UUID]) {
    queue.append(contentsOf: keys)
  }
  
  func replaceQueue(with keys: [UUID]) {
    self.queue = keys
  }
  
}
