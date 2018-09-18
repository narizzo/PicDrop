//
//  PostsView.swift
//  PicDrop
//
//  Created by Nicholas Rizzo on 8/12/18.
//  Copyright © 2018 Nicholas Rizzo. All rights reserved.
//

import UIKit

protocol PostsViewDelegate: class {
  func postsView(_ postsView: PostsView, didTapTakePicture: Bool)
}

class PostsView: UIView {

  // MARK: - Injection
  weak var delegate: PostsViewDelegate?
  
  // MARK: - Instance Variables
  /* Public */
  lazy var tinderImageViewManager: TinderImageViewManager = {
    let tiv = TinderImageViewManager()
    //tiv.delegate = self
    return tiv
  }()
  /* Private */
  private var isHUDHidden = true {
    didSet {
      setViews(hidden: isHUDHidden, duration: 0.2, views: verticalEllipsisButton, photoButton)
    }
  }
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
    blurView.frame = bounds
    return blurView
  }()
  private lazy var settingsMenu: SettingsMenu = {
    let sm = SettingsMenu(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    return sm
  }()
  
  // MARK: - Init
  init() {
    super.init(frame: .zero)
    setup()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setup()
  }
  
  private func setup() {
    setupView()
    addSubviews()
    setupTapRecognizer()
    setupProfileButton()
    setupTakePhotoButton()
  }
  
  // MARK: - View Configuration
  private func setupView() {
    translatesAutoresizingMaskIntoConstraints = false
    
    guard let window = window else {
      return
    }
    
    NSLayoutConstraint.activate([
      self.topAnchor.constraint(equalTo: window.safeAreaLayoutGuide.topAnchor),
      self.rightAnchor.constraint(equalTo: window.safeAreaLayoutGuide.rightAnchor),
      self.bottomAnchor.constraint(equalTo: window.safeAreaLayoutGuide.bottomAnchor),
      self.leftAnchor.constraint(equalTo: window.safeAreaLayoutGuide.leftAnchor),
      ])
    setNeedsLayout()
  }
  
  private func addSubviews() {
    //addSubview(tinderImageViewManager.view)
    addSubview(verticalEllipsisButton)
    addSubview(photoButton)
    addSubview(blurView)
    addSubview(settingsMenu)
  }
  
  private func setupTapRecognizer() {
    let tapGestureRecognizer = UITapGestureRecognizer()
    tapGestureRecognizer.addTarget(self, action: #selector(toggleHUD))
    addGestureRecognizer(tapGestureRecognizer)
  }
  
  private func setupTakePhotoButton() {
    photoButton.translatesAutoresizingMaskIntoConstraints = false
    
    NSLayoutConstraint.activate([
      photoButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
      photoButton.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor),
      photoButton.heightAnchor.constraint(equalToConstant: 80),
      photoButton.widthAnchor.constraint(equalToConstant: 80),
      ])
    
    photoButton.backgroundColor = UIColor.green
    photoButton.addTarget(self, action: #selector(handleTakePhotoTap), for: .touchUpInside)
  }
  
  
  @objc private func handleTakePhotoTap() {
    delegate?.postsView(self, didTapTakePicture: true)
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
      verticalEllipsisButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
      verticalEllipsisButton.rightAnchor.constraint(equalTo: safeAreaLayoutGuide.rightAnchor),
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
    let tapGesture = UITapGestureRecognizer()
    tapGesture.addTarget(self, action: #selector(dismissBlurViewAndSettingsMenu))
    blurView.addGestureRecognizer(tapGesture)
    
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
