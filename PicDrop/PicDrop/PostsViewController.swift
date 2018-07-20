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
  
  // MARK: - Instance Variables
  let imageView = UIImageView()
  
  private var isHUDHidden = false
  private let verticalEllipsisButton = UIButton()
  private let photoButton = UIButton()

  private lazy var photoDownloadManager: PhotoDownloadManager = {
    let manager = PhotoDownloadManager()
    manager.delegate = self
    return manager
  }()
  private lazy var blurView: UIVisualEffectView = {
    let blur = UIBlurEffect(style: UIBlurEffectStyle.dark)
    let blurView = UIVisualEffectView(effect: blur)
    blurView.alpha = 0.0
    blurView.frame = self.view.bounds
    
    return blurView
  }()
  private lazy var settingsMenu: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
    cv.backgroundColor = UIColor.cyan
    cv.translatesAutoresizingMaskIntoConstraints = false
    return cv
  }()
  
  // MARK: - ViewController Methods
  override func viewDidAppear(_ animated: Bool) {
    toggleHUD()
    locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
    //photoDownloadManager.getNearbyPosts()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    addSubviews()
    setupImageView()
    setupProfileButton()
    setupTakePhotoButton()
    setupSettingsMenu()
  }
  
  // MARK: - View Configuration
  private func addSubviews() {
    self.view.addSubview(imageView)
    self.view.addSubview(verticalEllipsisButton)
    self.view.addSubview(photoButton)
    self.view.addSubview(blurView)
    self.view.addSubview(settingsMenu)
  }
  
  private func setupImageView() {
    imageView.translatesAutoresizingMaskIntoConstraints = false
    
    NSLayoutConstraint.activate([
      imageView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
      imageView.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor),
      imageView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
      imageView.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor),
      ])
    
    let tapGestureRecognizer = UITapGestureRecognizer()
    tapGestureRecognizer.addTarget(self, action: #selector(toggleHUD))
    imageView.addGestureRecognizer(tapGestureRecognizer)
    imageView.isUserInteractionEnabled = true
    imageView.backgroundColor = UIColor.black
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
  
  private func setupSettingsMenu() {
    NSLayoutConstraint.activate([
      settingsMenu.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
      settingsMenu.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor),
      settingsMenu.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor),
      settingsMenu.heightAnchor.constraint(equalToConstant: 300)
      ])
    
    settingsMenu.setNeedsLayout()
    settingsMenu.layoutIfNeeded()
    
    settingsMenu.transform = CGAffineTransform(translationX: 0, y: settingsMenu.bounds.height)
  }
  
  @objc private func handleTakePhotoTap() {
    present(TakePictureViewController(), animated: true, completion: nil)
  }
  
  @objc private func toggleHUD() {
    isHUDHidden = !isHUDHidden
    setViews(hidden: isHUDHidden, duration: 0.2, views: verticalEllipsisButton, photoButton)
  }
  
  private func setViews(hidden: Bool, duration: TimeInterval, views: UIView...) {
    for view in views {
      UIView.transition(with: view, duration: duration, options: .transitionCrossDissolve, animations: {
        view.isHidden = hidden
      }, completion: { (completed) in
        if let button = view as? UIButton {
          button.isEnabled = !hidden // a button can't be seen or touched when (hidden == true && isEnabled == false)
        }
      })
    }
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
    UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut, animations: {
      self.settingsMenu.transform = CGAffineTransform(translationX: 0, y: 0)
    }, completion: nil)
  }
  
  
  private func hideSettingsMenu() {
    UIView.animate(withDuration: 0.15) {
      self.settingsMenu.transform = CGAffineTransform(translationX: 0, y: self.settingsMenu.bounds.height)
    }
  }
  
}
