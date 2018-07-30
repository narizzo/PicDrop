//
//  TinderImageView.swift
//  PicDrop
//
//  Created by Nicholas Rizzo on 7/20/18.
//  Copyright © 2018 Nicholas Rizzo. All rights reserved.
//

import UIKit

protocol TinderImageViewDelegate: class {
  func didSwipeLeft(on tinderImageView: TinderImageView)
  func didSwipeRight(on tinderImageView: TinderImageView)
}

class TinderImageView: UIImageView {

  weak var delegate: TinderImageViewDelegate?
  
  override func didMoveToSuperview() {
    layout()
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setup()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setup() {
    backgroundColor = UIColor.black
    isUserInteractionEnabled = true
    isOpaque = true
    translatesAutoresizingMaskIntoConstraints = false
    contentMode = .scaleAspectFill
    setupGestureRecognizers()
  }
  
  private func layout() {
    if let superview = superview {
      NSLayoutConstraint.activate([
        topAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.topAnchor),
        rightAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.rightAnchor),
        bottomAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.bottomAnchor),
        leftAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.leftAnchor),
        ])
    }
  }
  
  private func setupGestureRecognizers() {
    addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handlePan)))
  }
  
  @objc private func handlePan(gesture: UIPanGestureRecognizer) {
    let location = gesture.translation(in: self)
    switch gesture.state {
    case .began:
      beganTouching(at: location)
      return
    case .changed:
      isTouching(at: location)
      return
    case .ended:
      stoppedTouching()
      return
    default:
      return
    }
  }
  
  private func beganTouching(at location: CGPoint) {
    layer.shouldRasterize = true
    
    UIView.animate(withDuration: 0.1) {
      self.alpha = 0.5
    }
  }
  
  private func isTouching(at location: CGPoint) {
    transform = CGAffineTransform.init(translationX: location.x, y: 0)
    if abs(location.x) > (0.35 * self.bounds.width) {
      didVote(with: location.x)
    }
  }
  
  private func stoppedTouching() {
    layer.shouldRasterize = false
    
    UIView.animate(withDuration: 0.1) {
      self.alpha = 1
      self.transform = CGAffineTransform.identity
    }
  }
  
  private enum Direction: CGFloat {
    case right = 1.0
    case left = -1.0
  }
  
  private func didVote(with location: CGFloat) {
    if location > 0 {
      swipedRight()
      animatePhoto(.right)
    } else {
      swipedLeft()
      animatePhoto(.left)
    }
  }
  
  private func animatePhoto(_ direction: Direction) {
    UIView.animate(withDuration: 0.2, animations: {
      self.transform = CGAffineTransform.init(translationX: direction.rawValue * 100.0, y: 0)
    }) { (_) in
      print("Load new image")
    }
  }
  
  private func swipedLeft() {
    delegate?.didSwipeLeft(on: self)
  }
  
  private func swipedRight() {
    delegate?.didSwipeRight(on: self)
  }
  
  func setImage(to photo: UIImage) {
    image = photo
  }
  
  func showNoPhotosImage() {
    if let photo = UIImage(named: "NoPhoto") {
      setImage(to: photo)
    }
  }
  
}
