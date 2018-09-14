//
//  TinderImageViewManager.swift
//  PicDrop
//
//  Created by Nicholas Rizzo on 7/30/18.
//  Copyright © 2018 Nicholas Rizzo. All rights reserved.
//

import UIKit

protocol TinderImageViewManagerDelegate: class {
  func tinderImageViewManager(_ tinderImageViewManager: TinderImageViewManager, didVote vote: PostVote, for photo: Photo)
}

class TinderImageViewManager: UIView {
  
  // MARK: - Enum
  public enum imageQueueState {
    case needsPhoto
    case doesNotNeedPhoto
  }
  
  // MARK: - Injection
  weak var delegate: TinderImageViewManagerDelegate?
  
  // MARK: - Instance Variables
  lazy private var tinderImageQueue: [TinderImageView] = {
    let tis = [TinderImageView(), TinderImageView()]
    tis.forEach { (imageView) in
      imageView.delegate = self
      self.addSubview(imageView)
    }
    return tis
  }()
  var state = imageQueueState.needsPhoto
  
  // MARK: - Init
  init() {
    super.init(frame: .zero)
    setup()
  }
  
  required convenience init?(coder aDecoder: NSCoder) {
    self.init(coder: aDecoder)
    setup()
  }
  
  private func setup() {
    tinderImageQueue.forEach { (imageView) in
      addSubview(imageView)
    }
  }
  
  override func didMoveToSuperview() {
    setLayoutConstraints()
    setNeedsLayout()
  }
  
  // MARK: - Methods
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
  
//  private func setBackViewImage(to photo: Photo) {
//    guard let tinderImageView = subviews.first as? TinderImageView else {
//      return
//    }
//    tinderImageView.photo = photo
//  }
  
  
  func feedNext(_ photo: Photo) {
    guard let backView = tinderImageQueue.first else {
      return
    }
    backView.photo = photo
  }
  
}

extension TinderImageViewManager: TinderImageViewDelegate {
  func tinderImageView(_ tinderImageView: TinderImageView, didVote vote: PostVote, for photo: Photo) {
    switchImageViewOrder()
    delegate?.tinderImageViewManager(self, didVote: vote, for: photo)
  }
}

//struct RotatingQueue<T> {
//
//  var items: [T]
//
//  mutating func add(item: T) {
//    items.append(item)
//  }
//
//  mutating func popLast() -> T? {
//    return items.popLast()
//  }
//}
