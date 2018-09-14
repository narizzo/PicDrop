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
  private var networkManager: NetworkManager?
  
  // MARK: - Instance Variables
  /* Public */
  lazy var postQueue = PostQueue(delegate: self)
  lazy var photoQueue = PhotoQueue(delegate: self)
  lazy var postsView: PostsView = {
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
    super.init(coder: aDecoder)
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
    networkManager?.fetchPosts()
  }
  
  func fetchPhoto() {
    if let post = postQueue.popFirstPost() {
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
  
  func photoQueue(_ photoQueue: PhotoQueue, didReceivePhoto: Bool) {
    if postsView.tinderImageViewManager.state == .needsPhoto {
      postsView.tinderImageViewManager.feedNext(photoQueue.pop()!)
    }
  }
  
}
extension PostsViewController: PostQueueDelegate {
  
  func postQueue(_ postQueue: PostQueue, needsMorePosts: Bool) {
    fetchData()
  }
  
}
