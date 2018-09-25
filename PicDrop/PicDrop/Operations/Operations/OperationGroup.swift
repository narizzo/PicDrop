//
//  OperationGroup.swift
//  PicDrop
//
//  Created by Nicholas Rizzo on 9/21/18.
//  Copyright © 2018 Nicholas Rizzo. All rights reserved.
//

import UIKit

class OperationGroup: Operation {
  let internalQueue = OperationQueue()
  var finishingOperation = BlockOperation(block: {})
  
  override init() {
    internalQueue.isSuspended = true
    super.init()
  }
  
  final override func main() {
    finishingOperation.completionBlock = { [unowned self] in
      self.complete()
    }
    
    internalQueue.addOperation(finishingOperation)
    internalQueue.isSuspended = false
  }
  
  override func cancel() {
    internalQueue.cancelAllOperations()
    super.cancel()
  }
  
  func add(operation: Operation) {
    finishingOperation.addDependency(operation)
    internalQueue.addOperation(operation)
  }
  
  func add(operations: [Operation]) {
    operations.forEach {
      finishingOperation.addDependency($0)
      internalQueue.addOperation($0)
    }
  }
  
  private func complete() {
    print("Group Completion")
  }
  
  
  
}
