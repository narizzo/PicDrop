//
//  Queue.swift
//  PicDrop
//
//  Created by Nicholas Rizzo on 9/17/18.
//  Copyright © 2018 Nicholas Rizzo. All rights reserved.
//

/* Abstract: Generic Queue */

import Foundation

protocol QueueDelegate: class {
  func queue<T>(_ queue: Queue<T>, needsMoreElements: Bool)
}

class Queue<T> {

  // MARK: - Injection
  private weak var delegate: QueueDelegate?
  var needsMoreElementsThreshold: Int
  
  // MARK: - Instance Variables
  private var elements = [T]() {
    didSet {
      if elements.count <= needsMoreElementsThreshold {
        delegate?.queue(self, needsMoreElements: true)
      }
    }
  }
  
  // MARK: - Init
  init(delegate: QueueDelegate, needsMoreElementsThreshold: Int = 0) {
    self.delegate = delegate
    self.needsMoreElementsThreshold = needsMoreElementsThreshold
  }
  
  // MARK: - Methods
  func peek() -> T? {
    return elements.first
  }
  
  func pop() -> T? {
    guard elements.count > 0 else {
      return nil
    }
    return elements.removeFirst()
  }
  
  func addElement(_ element: T) {
    elements.append(element)
  }
  
  func addElements(_ elements: [T]) {
    elements.forEach { self.elements.append($0) }
  }
  
  func replaceElements(with elements: [T]) {
    self.elements = elements
  }
}

extension Queue where T: Equatable {
  func remove(_ element: T) {
    let indexOfElement = elements.index { $0 == element }
    if let index = indexOfElement {
      elements.remove(at: index)
    }
  }
}
