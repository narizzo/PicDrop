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
  
  // MARK: - Injection
  private var networkManager: NetworkManager
  private lazy var cacheObserver: NSKeyValueObservation = {
    let co = networkManager.cache.observe(\.nearbyKeys, options: [.new]) { (_, change) in
      guard let newKeys = change.newValue else {
        return
      }
      self.keyQueue.replaceQueue(with: newKeys)
    }
    return co
  }()
  
  // MARK: - Instance Variables
  /* File Private */
  fileprivate lazy var keyQueue = KeyQueue(delegate: self)
  fileprivate lazy var photoQueue = PostQueue(delegate: self)
  fileprivate lazy var postsView: PostsView = {
    let pv = PostsView()
    pv.delegate = self
    return pv
  }()
  
  
  //* Override */
  override var prefersStatusBarHidden: Bool {
    return true
  }
  
  // MARK: - Init
  init(networkManager: NetworkManager) {
    self.networkManager = networkManager
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("NetworkManager was not passed from AppDelegate")
  }
  
  // MARK: Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    fetchData()
  }
  
  override func loadView() {
    view = postsView
  }
  
  // MARK: - Network Calls
  func fetchData() {
    networkManager.fetchPosts()
  }
  
  func fetchPhoto() {
    if let post = keyQueue.popFirstKey() {
      //networkManager?.fetchPhoto(for: post)
    }
  }
  
}

extension PostsViewController: PostsViewDelegate {
  
  func postsView(_ postsView: PostsView, didTapTakePicture: Bool) {
    present(TakePictureViewController(), animated: true, completion: nil)
  }
}

extension PostsViewController: TinderImageViewManagerDelegate {
  func tinderImageViewManager(_ tinderImageViewManager: TinderImageViewManager, didVote vote: PostVote, for photo: Photo) {
    //networkManager?.vote(on: photo, with: vote)
    photoQueue.remove(photo)
  }
}

extension PostsViewController: PhotoQueueDelegate {
  
  func photoQueue(_ photoQueue: PostQueue, didReceivePhoto: Bool) {
    if postsView.tinderImageViewManager.state == .needsPhoto {
      postsView.tinderImageViewManager.feedNext(photoQueue.pop()!)
    }
  }
  
}
extension PostsViewController: KeyQueueDelegate {
  
  func keyQueue(_ postQueue: KeyQueue, needsMoreKeys: Bool) {
    fetchData()
  }
  
}
