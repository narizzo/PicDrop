//
//  TinderImageView.swift
//  PicDrop
//
//  Created by Nicholas Rizzo on 7/20/18.
//  Copyright © 2018 Nicholas Rizzo. All rights reserved.
//

import UIKit

protocol TinderImageViewDelegate: class {
  func tinderImageView(_ tinderImageView: TinderImageView, didVote vote: PostVote)
}

class TinderImageView: UIImageView {

  weak var delegate: TinderImageViewDelegate?
  
  init() {
    super.init(frame: .zero)
    setup()
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setup()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func didMoveToSuperview() {
    setLayoutConstraints()
    setNeedsLayout()
  }
  
  private func setLayoutConstraints() {
    if let superview = superview {
      translatesAutoresizingMaskIntoConstraints = false
      NSLayoutConstraint.activate([
        topAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.topAnchor),
        rightAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.rightAnchor),
        bottomAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.bottomAnchor),
        leftAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.leftAnchor),
        ])
    }
  }
  
  private func setup() {
    backgroundColor = UIColor.black
    isUserInteractionEnabled = true
    isOpaque = true
    contentMode = .scaleAspectFill
    setupGestureRecognizers()
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
  
  
  private func didVote(with location: CGFloat) {
    if location > 0 {
      delegate?.tinderImageView(self, didVote: .upvote)
      animatePhoto(.upvote)
    } else {
      delegate?.tinderImageView(self, didVote: .downvote)
      animatePhoto(.downvote)
    }
  }
  
  private func animatePhoto(_ vote: PostVote) {
    UIView.animate(withDuration: 0.2, animations: {
      self.transform = CGAffineTransform.init(translationX: CGFloat(vote.rawValue) * 100.0, y: 0)
    }) { (_) in
      print("Load new image")
    }
  }
  
  func setImage(to photo: UIImage) {
    image = photo
  }
  
}
