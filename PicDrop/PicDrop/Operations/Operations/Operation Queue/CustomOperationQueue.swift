//
//  CustomOperationQueue.swift
//  PicDrop
//
//  Created by Nicholas Rizzo on 9/18/18.
//  Copyright © 2018 Nicholas Rizzo. All rights reserved.
//

import Foundation

// Do I need this - what custom behavior am I adding in this wrapper?
// Answer: Tracking non-concurrent operations like [LocationOp-LocationQueryOp]

class CustomOperationQueue: OperationQueue {
  
  override func addOperation(_ op: Operation) {
    
  }
}
