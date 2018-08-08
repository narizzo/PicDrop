//
//  ViewController.swift
//  PicDrop
//
//  Created by Nicholas Rizzo on 6/24/18.
//  Copyright © 2018 Nicholas Rizzo. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseStorage
import FirebaseAuth
import GeoFire

class PostsViewController: UIViewController {
  
  // MARK: - Internal
  /* Public */
  var networkManager: NetworkManager!
  var locationManager: LocationManager!
  let notificationCenter = NotificationCenter.default
  var posts = [Post]() {
    didSet {
      print("********")
      posts.forEach { (post) in
        print(post.uuid)
      }
    }
  }
  
  /* Private */
  private var isHUDHidden = true {
    didSet {
      setViews(hidden: isHUDHidden, duration: 0.2, views: verticalEllipsisButton, photoButton)
    }
  }
  private lazy var reloadButton: UIButton = {
    let rb = UIButton()
    return rb
  }()
  private lazy var verticalEllipsisButton: UIButton = {
    let veb = UIButton()
    veb.isHidden = isHUDHidden
    return veb
  }()
  private lazy var photoButton: UIButton = {
    let pb = UIButton()
    pb.isHidden = isHUDHidden
    return pb
  }()
  
  private lazy var blurView: UIVisualEffectView = {
    let blur = UIBlurEffect(style: UIBlurEffectStyle.dark)
    let blurView = UIVisualEffectView(effect: blur)
    blurView.alpha = 0.0
    blurView.frame = self.view.bounds
    return blurView
  }()
  
  /* Internal */
  lazy var tinderImageViewManager: TinderImageViewManager = {
    let tiv = TinderImageViewManager()
    tiv.delegate = self
    return tiv
  }()
  lazy var settingsMenu: SettingsMenu = {
    let sm = SettingsMenu(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    return sm
  }()
  
  override var prefersStatusBarHidden: Bool {
    return true
  }
  
  // MARK: - ViewController Methods
  override func viewDidAppear(_ animated: Bool) {
    locationManager.setAccuracyForFindingPhotos()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    addObservers()
    fetchData()
    
    addSubviews()
    setupTapRecognizer()
    setupProfileButton()
    setupTakePhotoButton()
    setupReloadButton()
  }
  
  // MARK: - Observers
  private func addObservers() {
    notificationCenter.addObserver(self, selector: #selector(self.handleNearbyPosts(_:)), name: Constants.NotificationName.nearbyPostsName, object: nil)
  }
  
  @objc private func handleNearbyPosts(_ notification: NSNotification) {
    guard let nearbyPosts = notification.userInfo?["nearbyPosts"] as? NearbyPosts else {
      return
    }
    guard let postsArray = nearbyPosts.posts?.array else {
      return
    }
    
    if let posts = postsArray as? [Post] {
      self.posts = posts
    }
  }
  
  // MARK: - Fetch Data
  @objc private func fetchData() {
    if let location = locationManager.location {
      networkManager.fetchPosts(near: location)
    }
  }
  
  // MARK: - View Configuration
  private func addSubviews() {
    self.view.addSubview(tinderImageViewManager)
    self.view.addSubview(verticalEllipsisButton)
    self.view.addSubview(photoButton)
    self.view.addSubview(reloadButton)
    self.view.addSubview(blurView)
    self.view.addSubview(settingsMenu)
  }
  
  private func setupTapRecognizer() {
    let tapGestureRecognizer = UITapGestureRecognizer()
    tapGestureRecognizer.addTarget(self, action: #selector(toggleHUD))
    view.addGestureRecognizer(tapGestureRecognizer)
  }
  
  private func setupTakePhotoButton() {
    photoButton.translatesAutoresizingMaskIntoConstraints = false
    
    NSLayoutConstraint.activate([
      photoButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
      photoButton.centerXAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor),
      photoButton.heightAnchor.constraint(equalToConstant: 80),
      photoButton.widthAnchor.constraint(equalToConstant: 80),
      ])
    
    photoButton.backgroundColor = UIColor.green
    photoButton.addTarget(self, action: #selector(handleTakePhotoTap), for: .touchUpInside)
  }
  
  
  @objc private func handleTakePhotoTap() {
    present(TakePictureViewController(), animated: true, completion: nil)
  }
  
  @objc func toggleHUD() {
    isHUDHidden = !isHUDHidden
  }
  
  private func setViews(hidden: Bool, duration: TimeInterval, views: UIView...) {
    for view in views {
      UIView.transition(with: view, duration: duration, options: .transitionCrossDissolve, animations: {
        view.isHidden = hidden
      }, completion: nil
    )}
  }
  
  private func setupProfileButton() {
    verticalEllipsisButton.translatesAutoresizingMaskIntoConstraints = false
    
    NSLayoutConstraint.activate([
      verticalEllipsisButton.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
      verticalEllipsisButton.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor),
      verticalEllipsisButton.heightAnchor.constraint(equalToConstant: 80),
      verticalEllipsisButton.widthAnchor.constraint(equalToConstant: 80),
      ])
    
    verticalEllipsisButton.backgroundColor = UIColor.blue
    verticalEllipsisButton.addTarget(self, action: #selector(handleVerticalEllipsisTap), for: .touchUpInside)
  }
  
  private func setupReloadButton() {
    reloadButton.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      reloadButton.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
      reloadButton.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor),
      reloadButton.heightAnchor.constraint(equalToConstant: 80),
      reloadButton.widthAnchor.constraint(equalToConstant: 80),
      ])
    
    reloadButton.backgroundColor = UIColor.orange
    reloadButton.addTarget(self, action: #selector(fetchData), for: .touchUpInside)
  }
  
  // MARK: - HUD Methods
  @objc private func handleVerticalEllipsisTap() {
    showBlurView()
    showSettingsMenu()
  }
  
  private func showBlurView() {
    /* show blurView */
    
    // add tap dismissal to blurView
    let tapGesture = UITapGestureRecognizer()
    tapGesture.addTarget(self, action: #selector(dismissBlurViewAndSettingsMenu))
    blurView.addGestureRecognizer(tapGesture)
    
    // animate blur
    UIView.animate(withDuration: 0.2) {
      self.blurView.alpha = 0.8
    }
  }
  
  @objc private func dismissBlurViewAndSettingsMenu() {
    if let gesture = blurView.gestureRecognizers?.first {
      blurView.removeGestureRecognizer(gesture)
    }
    
    UIView.animate(withDuration: 0.2) {
      self.blurView.alpha = 0.0
    }
    
    hideSettingsMenu()
  }
  
  private func showSettingsMenu() {
    settingsMenu.show()
  }
  
  private func hideSettingsMenu() {
    settingsMenu.hide()
  }
  
}
