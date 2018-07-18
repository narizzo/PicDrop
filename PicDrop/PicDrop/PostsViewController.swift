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
  
  private lazy var imageView = UIImageView()
  private lazy var photoDownloadManager: PhotoDownloadManager = {
    let manager = PhotoDownloadManager()
    manager.delegate = self
    return manager
  }()
  //private var actionBar = UIView()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    addSubviews()
    setupImageView()
  }
  
  private func addSubviews() {
    self.view.addSubview(imageView)
    //self.view.addSubview(actionBar)
  }
  
  private func setupImageView() {
    imageView.translatesAutoresizingMaskIntoConstraints = false
    
    NSLayoutConstraint.activate([
      imageView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
      imageView.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor),
      imageView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
      imageView.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor),
      ])
  }
  
  override func viewDidAppear(_ animated: Bool) {
    locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
    photoDownloadManager.getNearbyPosts()
  }
}


extension PostsViewController: PhotoDownloadDelegate {
  
  func photoHasFinishedDownloading(_ photo: UIImage) {
    DispatchQueue.main.async {
      self.imageView.image = photo
    }
  }
  
}
