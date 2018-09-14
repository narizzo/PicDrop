//
//  AsynchronousOperation.swift
//  PicDrop
//
//  Created by Nicholas Rizzo on 9/12/18.
//  Copyright © 2018 Nicholas Rizzo. All rights reserved.
//

import Foundation

public class AsynchronousOperation: Operation {
  
  /// State for this operation.
  
  @objc private enum OperationState: Int {
    case ready
    case executing
    case finished
  }
  
  /// Concurrent queue for synchronizing access to `state`.
  
  private let stateQueue = DispatchQueue(label: Bundle.main.bundleIdentifier! + "asyncop", attributes: .concurrent)
  
  /// Private backing stored property for `state`.
  
  private var _state: OperationState = .ready
  
  /// The state of the operation
  
  @objc private dynamic var state: OperationState {
    get { return stateQueue.sync { _state } }
    set { stateQueue.sync(flags: .barrier) { _state = newValue } }
  }
  
  // MARK: - Various `Operation` properties
  
  open         override var isReady:        Bool { return state == .ready && super.isReady }
  public final override var isExecuting:    Bool { return state == .executing }
  public final override var isFinished:     Bool { return state == .finished }
  
  // KVN for dependent properties
  
  open override class func keyPathsForValuesAffectingValue(forKey key: String) -> Set<String> {
    if ["isReady", "isFinished", "isExecuting"].contains(key) {
      return [#keyPath(state)]
    }
    
    return super.keyPathsForValuesAffectingValue(forKey: key)
  }
  
  // Start
  
  public final override func start() {
    if isCancelled {
      finish()
      return
    }
    
    state = .executing
    
    main()
  }
  
  /// Subclasses must implement this to perform their work and they must not call `super`. The default implementation of this function throws an exception.
  
  open override func main() {
    fatalError("Subclasses must implement `main`.")
  }
  
  /// Call this function to finish an operation that is currently executing
  
  public final func finish() {
    if isExecuting { state = .finished }
  }
}
