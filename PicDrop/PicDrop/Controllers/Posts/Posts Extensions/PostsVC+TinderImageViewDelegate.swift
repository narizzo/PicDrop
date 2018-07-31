//
//  PostsVC+TinderImageViewDelegate.swift
//  PicDrop
//
//  Created by Nicholas Rizzo on 7/20/18.
//  Copyright © 2018 Nicholas Rizzo. All rights reserved.
//

import UIKit

extension PostsViewController: TinderImageViewManagerDelegate {
  func tinderImageViewManager(_ tinderImageViewManager: TinderImageViewManager, didVote vote: PostVote) {
    NetworkClient.shared.vote(on: postQueue.popFirstPost(), with: vote)
  }
  
  func requestNextImage(_ tinderImageViewManager: TinderImageViewManager) -> UIImage? {
    return UIImage()
  }
  
  
}
