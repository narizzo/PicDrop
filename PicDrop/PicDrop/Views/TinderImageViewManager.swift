//
//  TinderImageViewManager.swift
//  PicDrop
//
//  Created by Nicholas Rizzo on 7/30/18.
//  Copyright © 2018 Nicholas Rizzo. All rights reserved.
//

import UIKit

protocol TinderImageViewManagerDelegate: class {
  func tinderImageViewManager(_ tinderImageViewManager: TinderImageViewManager, didVote vote: PostVote)
}

class TinderImageViewManager: UIView {
 
  lazy private var tinderImageStack: [TinderImageView] = {
    let tis = [TinderImageView(), TinderImageView()]
    tis.forEach { (imageView) in
      imageView.delegate = self
      self.addSubview(imageView)
    }
    return tis
  }()
  
  weak var delegate: TinderImageViewManagerDelegate?
  
  init() {
    super.init(frame: .zero)
    tinderImageStack.forEach { (imageView) in
      addSubview(imageView)
    }
    // initialize back and front view images
    
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
  
  func switchImageViewOrder() {
    guard let backView = subviews.first else {
      return
    }
    self.bringSubview(toFront: backView)
  }
  
  func setBackViewImage(to photo: UIImage?) {
    guard let tinderImageView = subviews.first as? TinderImageView else {
      return
    }
    if let photo = photo {
      tinderImageView.setImage(to: photo)
    } else {
      tinderImageView.setImage(to: #imageLiteral(resourceName: "NoPhoto"))
    }
  }
}
