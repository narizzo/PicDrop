//
//  ViewController.swift
//  PicDrop
//
//  Created by Nicholas Rizzo on 6/24/18.
//  Copyright © 2018 Nicholas Rizzo. All rights reserved.
//

import UIKit
import CoreLocation
import FirebaseAuth

class PostsViewController: UIViewController {
  
  // MARK: - Injection
  let networkManager: NetworkManager
  let locationManager: CLLocationManager
  
  // MARK: Properties
  let operationQueue = OperationQueue()
  lazy var uuidQueue = Queue<UUID>(delegate: self)
  lazy var postQueue = Queue<PartialPost>(delegate: self, needsMoreElementsThreshold: 3)
  private var postsView = PostsView()
  override var prefersStatusBarHidden: Bool {
    return true
  }
  
  // MARK: - Init
  init(networkManager: NetworkManager, locationManager: CLLocationManager) {
    self.networkManager = networkManager
    self.locationManager = locationManager
    
    super.init(nibName: nil, bundle: nil)
    
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
  
  // MARK: - Network Calls
  func fetchData() {
    networkManager.fetchNearbyPostUUIDs()
  }
  
  func fetchPost() {
    if let uuid = uuidQueue.pop() {
      networkManager.fetchData(for: uuid)
    }
  }
  
  // MARK: - Post Propagation
  func feedNextPostToTinderImageViewManager() {
    let tivm = postsView.tinderImageViewManager
    if tivm.needsPost, let post = postQueue.pop() {
      tivm.feedNext(post)
    }
  }
}
