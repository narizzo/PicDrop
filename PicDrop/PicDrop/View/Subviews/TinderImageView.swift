//
//  TinderImageView.swift
//  PicDrop
//
//  Created by Nicholas Rizzo on 7/20/18.
//  Copyright © 2018 Nicholas Rizzo. All rights reserved.
//

import UIKit

protocol TinderImageViewDelegate: class {
  func tinderImageView(_ tinderImageView: TinderImageView, didVote vote: PostVote, for post: PartialPost)
}

class TinderImageView: UIImageView {

  // MARK: - Properties
  var post: PartialPost? {
    didSet { self.image = post?.image }
  }
  
  weak var delegate: TinderImageViewDelegate?
  
  // MARK: - Lifecycle
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
  
  // MARK: - Layout
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
  
  // MARK: - Setup
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
  
  // MARK: - Gestures
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
  
  // MARK: - Voting
  private func didVote(with touchLocationX: CGFloat) {
    guard let post = post else { return }
    
    // translate user touch into vote
    var vote = PostVote.upvote
    if touchLocationX < 0 { vote = .downvote }
    // send vote for post to delegate, animate the vote, set post to nil
    delegate?.tinderImageView(self, didVote: vote, for: post)
    animateImage(for: vote)
    self.post = nil
  }
  
  private func animateImage(for vote: PostVote) {
    UIView.animate(withDuration: 0.2, animations: {
      self.transform = CGAffineTransform.init(translationX: CGFloat(vote.rawValue) * 100.0, y: 0)
    }) { (_) in
      print("Load new image")
    }
  }
  
}
