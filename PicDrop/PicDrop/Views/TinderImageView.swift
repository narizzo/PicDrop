//
//  TinderImageView.swift
//  PicDrop
//
//  Created by Nicholas Rizzo on 7/20/18.
//  Copyright © 2018 Nicholas Rizzo. All rights reserved.
//

import UIKit

protocol TinderImageViewDelegate: class {
  func TinderImageViewTapped()
  func TinderImageViewSwipedLeft()
  func TinderImageViewSwipedRight()
}

class TinderImageView: UIImageView {

  var delegate: TinderImageViewDelegate?
  
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
    
    layout()
    setupGestureRecognizers()
  }
  
  private func layout() {
    translatesAutoresizingMaskIntoConstraints = false
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
    // tap
    let tapRecognizer = UITapGestureRecognizer()
    tapRecognizer.addTarget(self, action: #selector(tapped))
    addGestureRecognizer(tapRecognizer)
    
    // swipe left
    let swipeLeftRecognizer = UISwipeGestureRecognizer()
    swipeLeftRecognizer.addTarget(self, action: #selector(swipedLeft))
    swipeLeftRecognizer.direction = .left
    addGestureRecognizer(swipeLeftRecognizer)
    
    // swipe right
    let swipeRightRecognizer = UISwipeGestureRecognizer()
    swipeRightRecognizer.addTarget(self, action: #selector(swipedRight))
    swipeRightRecognizer.direction = .right
    addGestureRecognizer(swipeRightRecognizer)
  }
  
  @objc private func tapped() {
    delegate?.TinderImageViewTapped()
  }
  
  @objc private func swipedLeft() {
    delegate?.TinderImageViewSwipedLeft()
  }
  
  @objc private func swipedRight() {
    delegate?.TinderImageViewSwipedRight()
  }
  
  func setImage(to photo: UIImage) {
    image = photo
  }
  
}
