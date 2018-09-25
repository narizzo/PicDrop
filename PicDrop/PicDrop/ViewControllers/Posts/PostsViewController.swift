//
//  ViewController.swift
//  PicDrop
//
//  Created by Nicholas Rizzo on 6/24/18.
//  Copyright © 2018 Nicholas Rizzo. All rights reserved.
//

import UIKit
import FirebaseAuth

class PostsViewController: UIViewController {
  
  // MARK: Properties
  /* Internal */
  let operationQueue = OperationQueue()
  
  lazy var uuidQueue = Queue<UUID>(delegate: self)
  lazy var postQueue = Queue<Post>(delegate: self, needsMoreElementsThreshold: 3)
  
  private var postsView = PostsView()
  
  /* Injections */
  var networkManager: NetworkManager
  
  /* Override */
  override var prefersStatusBarHidden: Bool {
    return true
  }
  
  // MARK: - Init
  init(networkManager: NetworkManager) {
    self.networkManager = networkManager
    super.init(nibName: nil, bundle: nil)
    
    // change to KVO?
    self.networkManager.cache.delegate = self
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("Something went wrong while initializing PostsViewController.")
  }
  
  // MARK: Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    fetchData()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    // change so that self.view = postsView?
    postsView.delegate = self
    self.view.addSubview(postsView)
  }
  
  // MARK: - Post Propagation
  func feedNextPostToTinderImageViewManager() {
    let tivm = postsView.tinderImageViewManager
    if tivm.needsPost, let post = postQueue.pop() {
      tivm.feedNext(post)
    }
  }
  
  // MARK: - Network Calls
  func fetchData() {
    networkManager.fetchNearbyPostUUIDs()
  }
  
  func fetchPost() {
    if let uuid = uuidQueue.pop() {
      networkManager.fetchData(for: uuid)
    }
  }
}
