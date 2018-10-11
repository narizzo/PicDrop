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
  func queueDidRequestElements<T>(_ queue: Queue<T>)
  func queueDidRecieveElements<T>(_ queue: Queue<T>)
}

class Queue<T> {

  // MARK: - Injection
  private weak var delegate: QueueDelegate?
  var needsMoreElementsThreshold: Int // rename? minimumElements
  
  // MARK: - Instance Variables
  private var elements = [T]() {
    didSet {
      if elements.count <= needsMoreElementsThreshold {
        delegate?.queueDidRequestElements(self)
      }
      delegate?.queueDidRecieveElements(self)
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
  
  // necessary?
  func addElement(_ element: T) {
    elements.append(element)
  }
  
  func addElements(_ elements: [T]) {
    elements.forEach { self.elements.append($0) }
    delegate?.queueDidRecieveElements(self)
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
